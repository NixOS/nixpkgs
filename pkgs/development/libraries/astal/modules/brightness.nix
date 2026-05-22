{
  buildAstalModule,
  json-glib,
}:
buildAstalModule {
  name = "brightness";
  buildInputs = [ json-glib ];
  meta.description = "Astal module for brightness devices";
}
