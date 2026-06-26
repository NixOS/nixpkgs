{
  buildAstalModule,
  wl-vapi-gen,
}:
buildAstalModule {
  name = "wl";
  buildInputs = [ wl-vapi-gen ];
  meta.description = "Astal module for wayland connection management";
}
