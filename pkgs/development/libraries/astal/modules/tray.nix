{
  buildAstalModule,
  json-glib,
  vala-panel-appmenu,
}:
buildAstalModule {
  name = "tray";
  buildInputs = [
    json-glib
    vala-panel-appmenu
  ];
  meta.description = "Astal module for StatusNotifierItem";
}
