{input, stdenv, fetchurl, pkgconfig, gtk, perl, perlXMLParser, gettext}:

stdenv.mkDerivation {
  inherit (input) name src;
  buildInputs = [pkgconfig gtk perl perlXMLParser gettext];
}
