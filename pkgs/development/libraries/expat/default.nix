{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "expat-1.95.8";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/expat-1.95.8.tar.gz;
    md5 = "aff487543845a82fe262e6e2922b4c8e";
  };
}
