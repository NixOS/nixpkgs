{
  buildAstalModule,
  json-glib,
  quarrel,
}:
buildAstalModule {
  name = "brightness";
  buildInputs = [
    json-glib
    quarrel
  ];
  meta.description = "Astal module for brightness devices";
}
