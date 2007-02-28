{input, stdenv, fetchurl, pkgconfig, libxml2, glib}:

stdenv.mkDerivation {
  inherit (input) name src;
  buildInputs = [pkgconfig libxml2 glib];
}
