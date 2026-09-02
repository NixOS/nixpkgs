{
  buildAstalModule,
  gvfs,
  json-glib,
  libsoup_3,
  quarrel,
}:
buildAstalModule {
  name = "mpris";
  buildInputs = [
    gvfs
    json-glib
    libsoup_3
    quarrel
  ];
  meta.description = "Astal module for mpris players";
}
