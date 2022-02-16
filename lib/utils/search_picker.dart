import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef _OnItemBuild<T> = Widget Function(SearchPickerItem<T>);

class _SearchPicker<T> extends StatefulWidget {
  final List<SearchPickerItem<T>> items;
  final _OnItemBuild<T>? onItemBuild;
  const _SearchPicker({Key? key, required this.items, this.onItemBuild})
      : super(key: key);

  @override
  State<_SearchPicker> createState() => _SearchPickerState<T>();
}

class _SearchPickerState<T> extends State<_SearchPicker<T>> {
  String _query = "";
  @override
  Widget build(BuildContext context) {
    final List<SearchPickerItem<T>> filteredList = widget.items
        .where((element) =>
            element.label.toLowerCase().contains(_query.toLowerCase()))
        .toList();
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              CupertinoTextField(
                placeholder: "Search ...",
                onChanged: (value) {
                  setState(() {
                    _query = value;
                  });
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (_, index) {
                    final item = filteredList[index];
                    return widget.onItemBuild != null
                        ? CupertinoButton(
                            child: widget.onItemBuild!(item),
                            onPressed: () =>
                                Navigator.pop<T>(context, item.value),
                          )
                        : ListTile(
                            title: Text(item.label),
                            onTap: () {
                              Navigator.pop<T>(context, item.value);
                            },
                          );
                  },
                  itemCount: filteredList.length,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SearchPickerItem<T> {
  final String label;
  final T? value;

  SearchPickerItem({
    required this.label,
    required this.value,
  });
}

Future<T?> show_SearchPicker<T>(BuildContext context,
    {required List<SearchPickerItem<T>> items,
    _OnItemBuild<T>? onItemBuild}) async {
  return showDialog<T>(
    context: context,
    builder: (_) => _SearchPicker<T>(
      items: items,
      onItemBuild: onItemBuild,
    ),
  );
}
