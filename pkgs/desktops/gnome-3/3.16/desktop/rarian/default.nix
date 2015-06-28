{stdenv, fetchurl, pkgconfig, perl, perlXMLParser, libxml2, libxslt, docbook_xml_dtd_42}:

stdenv.mkDerivation rec {
  name = "rarian-0.8.1";
  src = fetchurl {
    url = "mirror://gnome/sources/rarian/0.8/${name}.tar.bz2";
    sha256 = "aafe886d46e467eb3414e91fa9e42955bd4b618c3e19c42c773026b205a84577";
  };

  buildInputs = [pkgconfig perl perlXMLParser libxml2 libxslt];
  configureFlags = "--with-xml-catalog=${docbook_xml_dtd_42}/xml/dtd/docbook/docbook.cat";

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
