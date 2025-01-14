{
  buildAstalModule,
  gtk4,
  gtk4-layer-shell,
  io,
}:
buildAstalModule {
  name = "astal4";
  sourceRoot = "lib/astal/gtk4";
  buildInputs = [
    io
    gtk4
    gtk4-layer-shell
  ];
  meta.description = "Astal module for GTK4 widgets";
}
