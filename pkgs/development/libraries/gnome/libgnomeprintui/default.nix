{input, stdenv, fetchurl, perl, perlXMLParser, pkgconfig, gtk, libgnomeprint, libgnomecanvas, gnomeicontheme}:

stdenv.mkDerivation {
  inherit (input) name src;

  buildInputs = [
    perl perlXMLParser pkgconfig
    gtk libgnomeprint libgnomecanvas gnomeicontheme
  ];
}
