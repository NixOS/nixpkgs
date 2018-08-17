{stdenv, fetchurl, pkgconfig, perl, perlXMLParser, libxml2, libxslt, docbook_xml_dtd_42, automake, gettext}:

stdenv.mkDerivation {
  name = "scrollkeeper-0.3.14";
  src = fetchurl {
    url = mirror://gnome/sources/scrollkeeper/0.3/scrollkeeper-0.3.14.tar.bz2;
    sha256 = "08n1xgj1f53zahwm0wpn3jid3rfbhi3iwby0ilaaldnid5qriqgc";
  };

  # The fuloong2f is not supported by scrollkeeper-0.3.14 config.guess
  preConfigure = "
    substituteInPlace extract/dtds/Makefile.am --replace /usr/bin/xmlcatalog xmlcatalog
    cp ${automake}/share/automake*/config.{sub,guess} .
  ";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ perl perlXMLParser libxml2 libxslt gettext];
  configureFlags = [ "--with-xml-catalog=${docbook_xml_dtd_42}/xml/dtd/docbook/catalog.xml" ];
}
