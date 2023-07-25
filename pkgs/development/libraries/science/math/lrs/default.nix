{ lib, stdenv, fetchurl, gmp }:

stdenv.mkDerivation {
  pname = "lrs";
  version = "7.2";

  src = fetchurl {
    url = "http://cgm.cs.mcgill.ca/~avis/C/lrslib/archive/lrslib-072.tar.gz";
    sha256 = "1w1jsnfgny8cihndr5gfm99pvwp48qsvxkqfsi2q87gd3m57aj7w";
  };

  buildInputs = [ gmp ];

  makeFlags = [
    "prefix=${placeholder "out"}"
    "CC:=$(CC)"
  ];

  meta = {
    description = "Implementation of the reverse search algorithm for vertex enumeration/convex hull problems";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
    homepage = "http://cgm.cs.mcgill.ca/~avis/C/lrs.html";
  };
}
