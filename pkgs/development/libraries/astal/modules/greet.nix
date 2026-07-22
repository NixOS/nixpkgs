{
  buildAstalModule,
  json-glib,
  quarrel,
}:
buildAstalModule {
  name = "greet";
  buildInputs = [
    json-glib
    quarrel
  ];
  meta.description = "Astal module for greetd using IPC";
}
