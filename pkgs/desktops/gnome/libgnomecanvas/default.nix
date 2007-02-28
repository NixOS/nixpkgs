{input, stdenv, fetchurl, pkgconfig, gtk, libart, libglade}:

assert pkgconfig != null && gtk != null && libart != null
  && libglade != null;

stdenv.mkDerivation {
  inherit (input) name src;
  buildInputs = [pkgconfig libglade];
  propagatedBuildInputs = [gtk libart];
}
