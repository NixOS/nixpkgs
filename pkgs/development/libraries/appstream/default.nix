{ stdenv, fetchurl, cmake, pkgconfig, gettext, intltool
, xmlto, docbook_xsl, docbook_xml_dtd_45
, glib, xapian, libxml2, libyaml, gobjectIntrospection
}:

stdenv.mkDerivation {
  name = "appstream-0.7.6";

  meta = with stdenv.lib; {
    description = "Software metadata handling library";
    homepage    = "http://www.freedesktop.org/wiki/Distributions/AppStream/Software/";
    longDescription =
    ''
      AppStream is a cross-distro effort for building Software-Center applications
      and enhancing metadata provided by software components.  It provides
      specifications for meta-information which is shipped by upstream projects and
      can be consumed by other software.
    '';
    license     = licenses.lgpl21Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ iyzsong ];
 };

  src = fetchurl {
    url = "https://github.com/ximion/appstream/archive/APPSTREAM_0_7_6.tar.gz";
    sha256 = "0djbngda3qbhvz1p0cqlsxy5iyshyrya0vh8xvc75y99agsrijkz";
  };

  nativeBuildInputs = [
    cmake pkgconfig gettext intltool
    xmlto docbook_xsl docbook_xml_dtd_45
    gobjectIntrospection
  ];

  buildInputs = [ glib xapian libxml2 libyaml ];
}
