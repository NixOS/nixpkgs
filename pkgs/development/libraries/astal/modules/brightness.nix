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
  meta.description = "Astal module for reading and controlling device brightness";
}
