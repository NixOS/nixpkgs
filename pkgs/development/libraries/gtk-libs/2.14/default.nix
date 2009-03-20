args: with args;

rec {

  glib = (import ./glib) args;

  atk = (import ./atk) (args // { inherit glib; });

  pango = (import ./pango) (args // { inherit glib cairo; });

  gtk = (import ./gtk+) (args // {
    inherit glib atk pango;
  });

  glibmm = (import ./glibmm) (args // { inherit glib; });

  pangomm = (import ./pangomm) (args // { inherit pango glibmm cairomm; });

  gtkmm = (import ./gtkmm) (args // { inherit gtk atk glibmm pangomm; });
}
