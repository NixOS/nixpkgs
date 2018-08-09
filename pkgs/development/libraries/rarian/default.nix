{stdenv, fetchurl, pkgconfig, perl, perlXMLParser, libxml2, libxslt, docbook_xml_dtd_42, gnome3}:
let
  pname = "rarian";
  version = "0.8.1";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.gz";
    sha256 = "aafe886d46e467eb3414e91fa9e42955bd4b618c3e19c42c773026b205a84577";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ perl perlXMLParser libxml2 libxslt];
  configureFlags = [ "--with-xml-catalog=${docbook_xml_dtd_42}/xml/dtd/docbook/docbook.cat" ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "Documentation metadata library based on the proposed Freedesktop.org spec";
    homepage = https://rarian.freedesktop.org/;
    license = licenses.lgpl21Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
