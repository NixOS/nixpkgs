{ stdenv, fetchFromGitHub, cmake, pkgconfig, gettext, intltool
, xmlto, docbook_xsl, docbook_xml_dtd_45
, glib, xapian, libxml2, libyaml, gobjectIntrospection
, pcre, itstool
}:

stdenv.mkDerivation rec {
  name = "appstream-${version}";
  version = "0.10.6";

  src = fetchFromGitHub {
    owner = "ximion";
    repo = "appstream";
    rev = "APPSTREAM_0_10_6";
    sha256 = "1fg7zxx2qhkyj7fmcpwbf80b72d16kyi8dadi111kf00sgzfbiyy";
  };

  nativeBuildInputs = [
    cmake pkgconfig gettext intltool
    xmlto docbook_xsl docbook_xml_dtd_45
    gobjectIntrospection itstool
  ];

  buildInputs = [ pcre glib xapian libxml2 libyaml ];

  cmakeFlags = ''
    -DSTEMMING=off
    '';
      
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
}
