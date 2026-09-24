{ buildAstalModule, json-glib }:
buildAstalModule {
  name = "powerprofiles";
  buildInputs = [ json-glib ];
  meta.description = "Astal module for upowerd profiles using DBus";
}
