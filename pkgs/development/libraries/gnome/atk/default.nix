{input, stdenv, fetchurl, pkgconfig, glib, perl}:

assert pkgconfig != null && glib != null && perl != null;

stdenv.mkDerivation {
  inherit (input) name src;
  buildInputs = [pkgconfig perl];
  propagatedBuildInputs = [glib];
}
