{ input, stdenv, fetchurl, pkgconfig, perl, perlXMLParser
, libxml2, libxslt, docbook_xml_dtd_42
}:

stdenv.mkDerivation {
  inherit (input) name src;
  patches = [./xmlcatalog.patch];
  buildInputs = [pkgconfig perl libxml2 libxslt];
  PERL5LIB = perlXMLParser ~ "/lib/site_perl"; # !!!
  inherit docbook_xml_dtd_42;
  builder = ./builder.sh;
}
