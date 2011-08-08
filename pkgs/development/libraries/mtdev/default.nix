{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "mtdev-1.1.0";

  src = fetchurl {
    url = "http://bitmath.org/code/mtdev/mtdev-1.1.0.tar.gz";
    sha256 = "14mky2vrzgy3x6k3rwkkpqkqyivbr6ym99gj5jmil9fqa9644lw4";
  };
}

