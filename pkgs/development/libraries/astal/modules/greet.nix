{ buildAstalModule, json-glib }:
buildAstalModule {
  name = "greet";
  buildInputs = [ json-glib ];
  meta.description = "Astal module for greetd using IPC";
}
