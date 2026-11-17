{
  buildAstalModule,
  json-glib,
  gdk-pixbuf,
  quarrel,
}:
buildAstalModule {
  name = "notifd";
  buildInputs = [
    json-glib
    gdk-pixbuf
    quarrel
  ];
  meta.description = "Astal module for notification daemon";
}
