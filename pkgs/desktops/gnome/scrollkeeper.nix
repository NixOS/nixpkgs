{ input, stdenv, fetchurl, pkgconfig, perl, perlXMLParser
, libxml2, libxslt, docbook_xml_dtd_42
}:

stdenv.mkDerivation {
  inherit (input) name src;
  preConfigure = "
    substituteInPlace extract/dtds/Makefile.am --replace /usr/bin/xmlcatalog xmlcatalog
  ";
  buildInputs = [pkgconfig perl perlXMLParser libxml2 libxslt];
  configureFlags = "--with-xml-catalog=${docbook_xml_dtd_42}/xml/dtd/docbook/docbook.cat";
}
