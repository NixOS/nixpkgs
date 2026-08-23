{
  buildAstalModule,
  json-glib,
  wl,
  wl-vapi-gen,
}:
buildAstalModule {
  name = "river";
  nativeBuildInputs = [ wl-vapi-gen ];
  buildInputs = [
    json-glib
    wl
  ];
  meta.description = "Astal module for River using IPC";

  postUnpack = ''
    rm -rf $sourceRoot/subprojects
    mkdir -p $sourceRoot/subprojects
    cp -r --remove-destination $src/lib/wayland-glib $sourceRoot/subprojects/wayland-glib
  '';
}
