{ input, stdenv, fetchurl, pkgconfig, perl, perlXMLParser, glib, gtk
, ORBit2, libgnome, libgnomeui, gnomedesktop, libglade, libwnck
, libjpeg, libpng, scrollkeeper, libXmu
}:

stdenv.mkDerivation {
  inherit (input) name src;
  buildInputs = [
    pkgconfig perl perlXMLParser gtk glib ORBit2 libgnome libgnomeui
    gnomedesktop libglade libwnck libjpeg libpng scrollkeeper
    libXmu
  ];
}
