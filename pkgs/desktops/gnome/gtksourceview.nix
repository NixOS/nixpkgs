{ input, stdenv, fetchurl, perl, perlXMLParser, pkgconfig
, gtk, libxml2, libgnomeprint, gnomevfs, libbonobo, GConf
, libgnomeprintui, libgnomecanvas
, gettext, intltool
}:

stdenv.mkDerivation {
  inherit (input) name src;
  buildInputs = [
    perl perlXMLParser pkgconfig gnomevfs
    libbonobo GConf libgnomeprintui libgnomecanvas
    gettext intltool
  ];
  propagatedBuildInputs = [gtk libxml2 libgnomeprint];
}
