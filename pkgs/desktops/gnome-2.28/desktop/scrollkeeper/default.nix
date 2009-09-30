{stdenv, fetchurl, pkgconfig, perl, perlXMLParser, libxml2, libxslt, docbook_xml_dtd_42}:

stdenv.mkDerivation {
  name = "scrollkeeper-0.3.14";
  src = fetchurl {
    url = mirror:/gnome/sources/scrollkeeper/0.3/scrollkeeper-0.3.14.tar.bz2.sha256sum;
    sha256 = "0anwj7481k1klnwblhlkdxls50fbaqk942flf0s1zcdjli6ari9v"
  };
  preConfigure = "
    substituteInPlace extract/dtds/Makefile.am --replace /usr/bin/xmlcatalog xmlcatalog
  ";
  buildInputs = [pkgconfig perl perlXMLParser libxml2 libxslt];
  configureFlags = "--with-xml-catalog=${docbook_xml_dtd_42}/xml/dtd/docbook/docbook.cat";
}
