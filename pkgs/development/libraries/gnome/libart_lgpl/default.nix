{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libart_lgpl-2.3.16";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/libart_lgpl-2.3.16.tar.bz2;
    md5 = "6bb13292b00649d01400a5b29a6c87cb";
  };
}
