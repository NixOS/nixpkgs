{
  buildAstalModule,
  json-glib,
  appmenu-glib-translator,
}:
buildAstalModule {
  name = "tray";
  buildInputs = [
    json-glib
    appmenu-glib-translator
  ];
  meta.description = "Astal module for StatusNotifierItem";
}
