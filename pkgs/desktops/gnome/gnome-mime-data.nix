{input, stdenv, fetchurl, pkgconfig, perl, perlXMLParser, gettext}:

assert pkgconfig != null && perl != null;

stdenv.mkDerivation {
  inherit (input) name src;
  buildInputs = [pkgconfig perl perlXMLParser gettext];
}
