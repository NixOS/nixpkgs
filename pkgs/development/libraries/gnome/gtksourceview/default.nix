{ input, stdenv, fetchurl, perl, perlXMLParser, pkgconfig
, gtk, libxml2, libgnomeprint, gnomevfs, libbonobo, gconf
, libgnomeprintui, libgnomecanvas
}:

stdenv.mkDerivation {
  inherit (input) name src;
  buildInputs = [
    perl perlXMLParser pkgconfig gnomevfs
    libbonobo gconf libgnomeprintui libgnomecanvas
  ];
  propagatedBuildInputs = [gtk libxml2 libgnomeprint];
  PERL5LIB = perlXMLParser ~ "/lib/site_perl"; # !!!
}
