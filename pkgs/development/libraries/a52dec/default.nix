{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "a52dec-0.7.4";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/a52dec-0.7.4.tar.gz;
    md5 = "caa9f5bc44232dc8aeea773fea56be80";
  };
}
