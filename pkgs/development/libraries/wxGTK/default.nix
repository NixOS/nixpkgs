{stdenv, fetchurl, pkgconfig, gtk, compat22 ? true}:

assert pkgconfig != null && gtk != null;
assert gtk.libtiff != null;
assert gtk.libjpeg != null;
assert gtk.libpng != null;
assert gtk.libpng.zlib != null;

stdenv.mkDerivation {
  name = "wxGTK-2.4.2";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/wxwindows/wxGTK-2.4.2.tar.bz2;
    md5 = "cdadfe82fc93f8a65a2ae18a95b0b0e3";
  };

  libtiff = gtk.libtiff;
  libjpeg = gtk.libjpeg;
  libpng = gtk.libpng;
  zlib = gtk.libpng.zlib;
  inherit pkgconfig gtk compat22;
}
