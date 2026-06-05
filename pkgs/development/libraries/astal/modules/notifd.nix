{
  buildAstalModule,
  json-glib,
  gdk-pixbuf,
}:
buildAstalModule {
  name = "notifd";
  buildInputs = [
    json-glib
    gdk-pixbuf
  ];
  meta.description = "Astal module for notification daemon";
}
