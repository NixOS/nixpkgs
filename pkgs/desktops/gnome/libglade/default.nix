{input, stdenv, fetchurl, pkgconfig, gtk, libxml2}:

assert pkgconfig != null && gtk != null && libxml2 != null;

stdenv.mkDerivation {
  inherit (input) name src;
  buildInputs = [pkgconfig];
  propagatedBuildInputs = [gtk libxml2];
}
