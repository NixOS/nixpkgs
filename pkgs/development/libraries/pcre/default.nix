{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "pcre-4.5";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/pcre-4.5.tar.bz2;
    md5 = "c51bd34197008b128046f0799d2242e4";
  };
}
