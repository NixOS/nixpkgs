{ input, stdenv, fetchurl, pkgconfig, perl, perlXMLParser, glib, gtk
, libgnomeui, scrollkeeper, libjpeg
}:

stdenv.mkDerivation {
  inherit (input) name src;
  buildInputs = [pkgconfig perl perlXMLParser gtk glib libgnomeui scrollkeeper libjpeg];
}
