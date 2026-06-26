{
  buildAstalModule,
  wl,
}:
buildAstalModule {
  name = "river";
  buildInputs = [ wl ];
  meta.description = "Astal module for River using IPC";
}
