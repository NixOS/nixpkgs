{stdenv, fetchurl, pkgconfig, glib}:

assert pkgconfig != null && glib != null;

stdenv.mkDerivation {
  name = "gnet-2.0.4";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.gnetlibrary.org/src/gnet-2.0.4.tar.gz;
    md5 = "b43e728391143214e2cfd0b835b6fd2a";
  };
  pkgconfig = pkgconfig;
  glib = glib;
}
