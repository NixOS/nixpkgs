{
  buildAstalModule,
  json-glib,
}:
buildAstalModule {
  name = "apps";
  buildInputs = [ json-glib ];
  meta.description = "Astal module for application query";
}
