{input, stdenv, fetchurl, pkgconfig, gtk}:

stdenv.mkDerivation {
  inherit (input) name src;
  buildInputs = [pkgconfig gtk];
}
