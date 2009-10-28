{stdenv, fetchurl, gtk, libtiff, libjpeg, libpng}:

stdenv.mkDerivation rec {
  name = "gdk-pixbuf-0.22.0";

  src = fetchurl {
    url = "ftp://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/0.22/${name}.tar.bz2";
    md5 = "05fcb68ceaa338614ab650c775efc2f2";
  };

  buildInputs = [libtiff libjpeg libpng];
  propagatedBuildInputs = [gtk];
}
