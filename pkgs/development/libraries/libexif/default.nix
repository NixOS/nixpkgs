{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libexif-0.6.11";

  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/libexif-0.6.11.tar.bz2;
    md5 = "211996a336f1b1a06def5a6d5c94284e";
  };

  patches = [./no-po.patch];
}
