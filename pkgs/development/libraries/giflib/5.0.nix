{stdenv, fetchurl, xmlto, docbook_xml_dtd_412, docbook_xsl, libxml2 }:

stdenv.mkDerivation {
  name = "giflib-5.0.5";
  src = fetchurl {
    url = mirror://sourceforge/giflib/giflib-5.0.5.tar.bz2;
    sha256 = "02c6pwll9pzw5fhg5gccx2ws56d70ylfryk21nv5lqhwdcv8lvb0";
  };

  buildInputs = [ xmlto docbook_xml_dtd_412 docbook_xsl libxml2 ];
}

