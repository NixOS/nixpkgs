{input, stdenv, fetchurl, pkgconfig, x11}:

stdenv.mkDerivation {
  inherit (input) name src;
  buildInputs = [pkgconfig x11];
}
