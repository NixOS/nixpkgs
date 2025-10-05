{
  buildAstalModule,
  json-glib,
}:
buildAstalModule {
  name = "battery";
  buildInputs = [ json-glib ];
  meta.description = "Astal module for upowerd devices (DBus proxy)";
}
