{stdenv, fetchurl, gtk, libtiff, libjpeg, libpng}:

assert gtk != null && libtiff != null
  && libjpeg != null && libpng != null;

stdenv.mkDerivation {
  name = "gdk-pixbuf-0.22.0";

  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/0.22/gdk-pixbuf-0.22.0.tar.bz2;
    md5 = "05fcb68ceaa338614ab650c775efc2f2";
  };

  buildInputs = [gtk libtiff libjpeg libpng];
}
