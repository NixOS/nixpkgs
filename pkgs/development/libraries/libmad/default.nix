{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libmad-0.15.0b";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/libmad-0.15.0b.tar.gz;
    md5 = "2e4487cdf922a6da2546bad74f643205";
  };
}
