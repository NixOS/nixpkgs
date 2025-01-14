{
  buildAstalModule,
  gvfs,
  json-glib,
}:
buildAstalModule {
  name = "mpris";
  buildInputs = [
    gvfs
    json-glib
  ];
  meta.description = "Astal module for mpris players";
}
