{stdenv, fetchurl}:

derivation {
  name = "libart_lgpl-2.3.16";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://ftp.gnome.org/pub/GNOME/desktop/2.4/2.4.1/sources/libart_lgpl-2.3.16.tar.bz2;
    md5 = "6bb13292b00649d01400a5b29a6c87cb";
  };
  stdenv = stdenv;
}
