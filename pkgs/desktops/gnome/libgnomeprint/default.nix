{input, stdenv, fetchurl, perl, perlXMLParser, pkgconfig, glib, pango, libart, libxml2, popt, bison, flex}:

stdenv.mkDerivation {
  inherit (input) name src;

  buildInputs = [
    perl perlXMLParser pkgconfig popt libxml2
    glib pango bison flex
  ];

  propagatedBuildInputs = [libxml2 libart];
}
