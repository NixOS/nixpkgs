{stdenv, fetchurl, gtk, libtiff, libjpeg, libpng}:

assert !isNull gtk && !isNull libtiff
  && !isNull libjpeg && !isNull libpng;

derivation {
  name = "gdk-pixbuf-0.22.0";
  system = stdenv.system;

  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/0.22/gdk-pixbuf-0.22.0.tar.bz2;
    md5 = "05fcb68ceaa338614ab650c775efc2f2";
  };

  buildInputs = [gtk libtiff libjpeg libpng];
  inherit stdenv;
}
