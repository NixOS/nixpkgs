{ input, stdenv, fetchurl, gnome, pkgconfig, perl, perlXMLParser
, esound, libjpeg, gettext, intltool
}:

stdenv.mkDerivation {
  inherit (input) name src;
  buildInputs = [
    pkgconfig perl perlXMLParser gnome.libglade esound libjpeg gettext
    intltool
  ];
  propagatedBuildInputs = [
    gnome.libgnome gnome.libgnomecanvas gnome.libbonoboui libjpeg
    gnome.gnomekeyring
  ];
}
