{ buildAstalModule }:
buildAstalModule {
  name = "wl";
  buildInputs = [ ];
  meta.description = "Central wayland connection manager";
  # needs https://codeberg.org/kotontrion/wl-vapi-gen,
  # which has 11 commits and needs to be packaged
  meta.broken = true;
}
