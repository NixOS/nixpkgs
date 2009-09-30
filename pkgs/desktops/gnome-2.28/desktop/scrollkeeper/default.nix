{stdenv, fetchurl, pkgconfig, perl, perlXMLParser, libxml2, libxslt, docbook_xml_dtd_42}:

stdenv.mkDerivation {
  name = "scrollkeeper-0.3.14";
  src = fetchurl {
    url = mirror://gnome/sources/scrollkeeper/0.3/scrollkeeper-0.3.14.tar.bz2;
    sha256 = "08n1xgj1f53zahwm0wpn3jid3rfbhi3iwby0ilaaldnid5qriqgc";
  };
  preConfigure = "
    substituteInPlace extract/dtds/Makefile.am --replace /usr/bin/xmlcatalog xmlcatalog
  ";
  buildInputs = [pkgconfig perl perlXMLParser libxml2 libxslt];
  configureFlags = "--with-xml-catalog=${docbook_xml_dtd_42}/xml/dtd/docbook/docbook.cat";
}
