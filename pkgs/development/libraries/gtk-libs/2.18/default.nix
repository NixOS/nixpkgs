args: with args;

rec {

  glib = (import ./glib) args;

  atk = (import ./atk) (args // { inherit glib; });

  pango = (import ./pango) (args // { inherit glib cairo; });

  gtk = import ./gtk+ {
    inherit stdenv fetchurl pkgconfig x11 glib atk pango libtiff
      libjpeg libpng cairo libXrandr libXinerama perl jasper
      cups openssl;
  };

  glibmm = (import ./glibmm) (args // { inherit glib; });

  pangomm = (import ./pangomm) (args // { inherit pango glibmm cairomm; });

  gtkmm = (import ./gtkmm) (args // { inherit gtk atk glibmm pangomm; });
}
