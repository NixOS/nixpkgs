{stdenv, fetchurl, xmlto, docbook_xml_dtd_412, docbook_xsl, libxml2 }:

stdenv.mkDerivation {
  name = "giflib-4.2.3";
  src = fetchurl {
    url = mirror://sourceforge/giflib/giflib-4.2.3.tar.bz2;
    sha256 = "0rmp7ipzk42r841bggd7bfqk4p8qsssbp4wcck4qnz7p4rkxbj0a";
  };

  buildInputs = [ xmlto docbook_xml_dtd_412 docbook_xsl libxml2 ];
}

