{ input, stdenv, fetchurl, gnome, pkgconfig, perl, perlXMLParser
, ncurses, python, gettext
}:

stdenv.mkDerivation {
  inherit (input) name src;
  
  buildInputs = [
    pkgconfig perl perlXMLParser gnome.glib gnome.gtk python gettext
  ];
  
  propagatedBuildInputs = [ncurses];
}
