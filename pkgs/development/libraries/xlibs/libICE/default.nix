{stdenv, fetchurl, pkgconfig, libX11}:

stdenv.mkDerivation {
  name = "libICE-6.3.3";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/libICE-6.3.3.tar.bz2;
    md5 = "e67d98bebfabf884e58501e44b7efd35";
  };
  buildInputs = [pkgconfig libX11];
}
