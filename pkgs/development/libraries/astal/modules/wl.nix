{ buildAstalModule, wl-vapi-gen }:
buildAstalModule {
  name = "wl";
  nativeBuildInputs = [ wl-vapi-gen ];
  meta.description = "Central wayland connection manager";
}
