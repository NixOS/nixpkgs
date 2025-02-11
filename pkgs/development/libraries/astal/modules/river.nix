{ buildAstalModule, json-glib }:
buildAstalModule {
  name = "river";
  buildInputs = [ json-glib ];
  meta.description = "Astal module for River using IPC";

  postUnpack = ''
    rm -rf $sourceRoot/subprojects
    mkdir -p $sourceRoot/subprojects
    cp -r --remove-destination $src/lib/wayland-glib $sourceRoot/subprojects/wayland-glib
  '';
}
