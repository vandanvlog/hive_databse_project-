import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_project/boxes/boxes.dart';
import 'package:hive_project/models/notes_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showMyDialog();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.

      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, box, _) {
          var data = box.values.toList().cast<NotesModel>();
          return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(data[index].title.toString()),
                            const Spacer(),
                            InkWell(
                                onTap: () {
                                  _editDialog(
                                      data[index],
                                      data[index].title.toString(),
                                      data[index].description.toString());
                                },
                                child: const Icon(Icons.edit)),
                            const SizedBox(
                              width: 20,
                            ),
                            InkWell(
                                onTap: () {
                                  delete(data[index]);
                                },
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ))
                          ],
                        ),
                        Text(data[index].description.toString()),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }

  void delete(NotesModel notesModel) async {
    await notesModel.delete();
  }

  Future<void> _editDialog(
      NotesModel notesModel, String tittle, String description) async {
    titleController.text = tittle;
    descriptionController.text = description;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text('Edit notes '),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(
                          hintText: "Enter Title",
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                          hintText: "Enter description",
                          border: OutlineInputBorder()),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('cancale')),
                TextButton(
                    onPressed: () async {
                      notesModel.title = titleController.text.toString();
                      notesModel.description =
                          descriptionController.text.toString();

                      notesModel.save();

                      titleController.clear();
                      descriptionController.clear();

                      Navigator.pop(context);
                    },
                    child: const Text('edit')),
              ]);
        });
  }

  Future<void> _showMyDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text('Add notes '),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(
                          hintText: "Enter Title",
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                          hintText: "Enter description",
                          border: OutlineInputBorder()),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('cancale')),
                TextButton(
                    onPressed: () {
                      final data = NotesModel(
                          title: titleController.text,
                          description: descriptionController.text);

                      final box = Boxes.getData();
                      box.add(data);

                      data.save();
                      titleController.clear();
                      descriptionController.clear();

                      Navigator.pop(context);
                    },
                    child: const Text('add')),
              ]);
        });
  }
}
