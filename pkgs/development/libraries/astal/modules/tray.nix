{
  buildAstalModule,
  json-glib,
}:
buildAstalModule {
  name = "tray";
  buildInputs = [ json-glib ];
  meta.description = "Astal module for StatusNotifierItem";
  meta.broken = true; # https://github.com/NixOS/nixpkgs/issues/337630
}
