{ input, stdenv, fetchurl, pkgconfig, perl, perlXMLParser
, libxml2, libxslt, docbook_xml_dtd_42
}:

stdenv.mkDerivation {
  inherit (input) name src;
  patches = [./xmlcatalog.patch];
  buildInputs = [pkgconfig perl perlXMLParser libxml2 libxslt];
  inherit docbook_xml_dtd_42;
  builder = ./builder.sh;
}
