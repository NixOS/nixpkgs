{stdenv, fetchurl, pkgconfig, gtk, compat22 ? true}:

assert !isNull pkgconfig && !isNull gtk;
assert !isNull gtk.libtiff;
assert !isNull gtk.libjpeg;
assert !isNull gtk.libpng;
assert !isNull gtk.libpng.zlib;

derivation {
  name = "wxGTK-2.4.2";
  system = stdenv.system;

  builder = ./builder.sh;
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/wxwindows/wxGTK-2.4.2.tar.bz2;
    md5 = "cdadfe82fc93f8a65a2ae18a95b0b0e3";
  };

  libtiff = gtk.libtiff;
  libjpeg = gtk.libjpeg;
  libpng = gtk.libpng;
  zlib = gtk.libpng.zlib;
  inherit stdenv pkgconfig gtk compat22;
}
