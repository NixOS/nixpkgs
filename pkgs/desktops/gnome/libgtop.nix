{ input, stdenv, fetchurl, gnome, pkgconfig, perl, perlXMLParser, popt
, gettext
}:

stdenv.mkDerivation {
  inherit (input) name src;
  
  buildInputs = [
    pkgconfig perl perlXMLParser gnome.glib popt gettext
  ];
}
