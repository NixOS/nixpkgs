{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "lcms-1.14";

  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/lcms-1.14.tar.gz;
    md5 = "5a803460aeb10e762d97e11a37462a69";
  };
}
