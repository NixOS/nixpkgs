{input, stdenv, fetchurl, pkgconfig, atk, gtk, libgnomecanvas}:

stdenv.mkDerivation {
  inherit (input) name src;
  buildInputs = [pkgconfig atk gtk libgnomecanvas];
  propagatedBuildInputs = [libgnomecanvas];
}
