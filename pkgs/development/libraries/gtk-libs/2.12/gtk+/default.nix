args: with args;

stdenv.mkDerivation {
  name = "gtk+-2.12.9";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v2.12/gtk+-2.12.9.tar.bz2;
    sha256 = "1j0fil4rzvkrlq3mwpb5mpwks1h5sk580qq54l69y99incgvznav";
  };
  buildInputs = [ pkgconfig perl ];
  propagatedBuildInputs = [x11 glib atk pango libtiff libjpeg libpng cairo
    libXrandr (if xineramaSupport then libXinerama else null)];
  passthru = { inherit libtiff libjpeg libpng; };
}
