{stdenv, fetchurl, pkgconfig, glib, libIDL, popt}:

assert pkgconfig != null && glib != null && libIDL != null
  && popt != null;

stdenv.mkDerivation {
  name = "ORBit2-2.8.3";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.gnome.org/pub/gnome/sources/ORBit2/2.8/ORBit2-2.8.3.tar.bz2;
    md5 = "c6c4b63de2f70310e33a52a37257ddaf";
  };
  pkgconfig = pkgconfig;
  glib = glib;
  libIDL = libIDL;
  popt = popt;
}
