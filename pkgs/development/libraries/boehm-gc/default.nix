{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "boehm-gc-6.3";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/gc6.3.tar.gz;
    md5 = "8b37ee18cbeb1dfd1866958e280db871";
  };
}
