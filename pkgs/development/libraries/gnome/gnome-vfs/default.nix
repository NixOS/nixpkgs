{input, stdenv, fetchurl, pkgconfig, perl, glib, libxml2, gconf
, libbonobo, gnomemimedata, popt, bzip2, perlXMLParser }:

assert pkgconfig != null && perl != null && glib != null
  && libxml2 != null && gconf != null && libbonobo != null
  && gnomemimedata != null && bzip2 != null;

stdenv.mkDerivation {
  inherit (input) name src;
  buildInputs = [
    pkgconfig perl glib libxml2 gconf libbonobo
    gnomemimedata popt bzip2 perlXMLParser
  ];
  patches = [./no-kerberos.patch];
}
