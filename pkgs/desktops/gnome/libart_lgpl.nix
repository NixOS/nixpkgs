{input, stdenv, fetchurl}:

stdenv.mkDerivation {
  inherit (input) name src;
}
