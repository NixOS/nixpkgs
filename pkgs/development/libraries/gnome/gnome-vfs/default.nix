{ input, stdenv, fetchurl, pkgconfig, perl, glib, libxml2, GConf
, libbonobo, gnomemimedata, popt, perlXMLParser, gettext, bzip2
}:

assert pkgconfig != null && perl != null && glib != null
  && libxml2 != null && GConf != null && libbonobo != null
  && gnomemimedata != null;

stdenv.mkDerivation {
  inherit (input) name src;
  buildInputs = [
    pkgconfig perl glib libxml2 GConf libbonobo
    gnomemimedata popt perlXMLParser gettext bzip2
  ];
  patches = [./no-kerberos.patch];
}
