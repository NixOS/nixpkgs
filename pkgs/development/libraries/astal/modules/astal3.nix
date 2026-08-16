{
  buildAstalModule,
  gtk3,
  gtk-layer-shell,
  io,
}:
buildAstalModule {
  name = "astal3";
  sourceRoot = "lib/astal/gtk3";
  buildInputs = [ io ];
  propagatedBuildInputs = [
    gtk3
    gtk-layer-shell
  ];
  meta.description = "Astal module for GTK3 widgets";
}
