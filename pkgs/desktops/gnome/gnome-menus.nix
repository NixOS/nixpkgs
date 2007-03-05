{ input, stdenv, fetchurl, gnome, pkgconfig, perl, perlXMLParser
, python, gettext
}:

stdenv.mkDerivation {
  inherit (input) name src;
  buildInputs = [
    pkgconfig perl perlXMLParser gnome.glib python gettext
  ];
}
