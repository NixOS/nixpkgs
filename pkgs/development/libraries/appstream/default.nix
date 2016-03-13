{ stdenv, fetchurl, cmake, pkgconfig, gettext, intltool
, xmlto, docbook_xsl, docbook_xml_dtd_45
, glib, xapian, libxml2, libyaml, gobjectIntrospection
}:

stdenv.mkDerivation {
  name = "appstream-0.8.0";

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
 };

  src = fetchurl {
    url = "https://github.com/ximion/appstream/archive/APPSTREAM_0_8_0.tar.gz";
    sha256 = "16a3b38avrwyl1pp8jdgfjv6cd5mccbmk4asni92l40y5r0xfycr";
  };

  nativeBuildInputs = [
    cmake pkgconfig gettext intltool
    xmlto docbook_xsl docbook_xml_dtd_45
    gobjectIntrospection
  ];

  buildInputs = [ glib xapian libxml2 libyaml ];
}
