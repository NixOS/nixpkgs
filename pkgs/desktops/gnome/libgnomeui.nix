{ input, stdenv, fetchurl, gnome, pkgconfig, perl, perlXMLParser
, esound, libjpeg, gettext
}:

stdenv.mkDerivation {
  inherit (input) name src;
  buildInputs = [
    pkgconfig perl perlXMLParser gnome.libglade esound libjpeg gettext
  ];
  propagatedBuildInputs = [
    gnome.libgnome gnome.libgnomecanvas gnome.libbonoboui libjpeg
    gnome.gnomekeyring
  ];
}
