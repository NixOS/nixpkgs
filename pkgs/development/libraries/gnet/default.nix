{stdenv, fetchurl, pkgconfig, glib}:

assert !isNull pkgconfig && !isNull glib;

derivation {
  name = "gnet-2.0.4";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.gnetlibrary.org/src/gnet-2.0.4.tar.gz;
    md5 = "b43e728391143214e2cfd0b835b6fd2a";
  };
  stdenv = stdenv;
  pkgconfig = pkgconfig;
  glib = glib;
}
