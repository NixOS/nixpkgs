{ buildAstalModule, json-glib }:
buildAstalModule {
  name = "river";
  buildInputs = [ json-glib ];
  meta.description = "Astal module for River using IPC";
  # needs https://codeberg.org/kotontrion/wl-vapi-gen,
  # which has 11 commits and needs to be packaged
  meta.broken = true;

  postUnpack = ''
    rm -rf $sourceRoot/subprojects
    mkdir -p $sourceRoot/subprojects
    cp -r --remove-destination $src/lib/wayland-glib $sourceRoot/subprojects/wayland-glib
  '';
}
