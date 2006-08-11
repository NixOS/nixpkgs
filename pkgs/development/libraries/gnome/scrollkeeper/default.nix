{ input, stdenv, fetchurl, pkgconfig, perl, perlXMLParser
, libxml2, libxslt, docbook_xml_dtd_42
}:

stdenv.mkDerivation {
  inherit (input) name src;
  patches = [./xmlcatalog.patch];
  buildInputs = [pkgconfig perl perlXMLParser libxml2 libxslt];
  configureFlags = "--with-xml-catalog=${docbook_xml_dtd_42}/xml/dtd/docbook/docbook.cat";
}
