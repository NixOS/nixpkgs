{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libXtrans-0.1";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/libXtrans-0.1.tar.bz2;
    md5 = "a5ae4c7a75f930053b8327f7bd0c1361";
  };
}
