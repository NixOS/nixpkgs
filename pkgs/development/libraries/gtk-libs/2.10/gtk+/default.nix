args: with args;

stdenv.mkDerivation {
  name = "gtk+-2.10.14";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v2.10/gtk+-2.10.14.tar.bz2;
    sha256 = "1qjdx9kdc533dajdy1kv3ssxzh7gz7j7vzgw0ax910q4klil88yh";
  };
  buildInputs = [ pkgconfig perl ];
  propagatedBuildInputs = [x11 glib atk pango libtiff libjpeg libpng cairo
    libXrandr (if xineramaSupport then libXinerama else null)];
  passthru = { inherit libtiff libjpeg libpng; };
}
