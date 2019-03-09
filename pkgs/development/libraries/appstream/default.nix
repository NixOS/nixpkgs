{ stdenv, fetchpatch, fetchFromGitHub, meson, ninja, pkgconfig, gettext
, xmlto, docbook_xsl, docbook_xml_dtd_45, libxslt
, libstemmer, glib, xapian, libxml2, libyaml, gobject-introspection
, pcre, itstool, gperf, vala
}:

stdenv.mkDerivation rec {
  name = "appstream-${version}";
  version = "0.12.6";

  src = fetchFromGitHub {
    owner  = "ximion";
    repo   = "appstream";
    rev    = "APPSTREAM_${stdenv.lib.replaceStrings ["."] ["_"] version}";
    sha256 = "0hbl26aw3g2hag7z4di9z59qz057qcywrxpnnmp86z7rngvjbqpx";
  };

  nativeBuildInputs = [
    meson ninja pkgconfig gettext
    libxslt xmlto docbook_xsl docbook_xml_dtd_45
    gobject-introspection itstool vala
  ];

  buildInputs = [ libstemmer pcre glib xapian libxml2 libyaml gperf ];

  prePatch = ''
    substituteInPlace meson.build \
      --replace /usr/include ${libstemmer}/include

    substituteInPlace data/meson.build \
      --replace /etc $out/etc
  '';

  mesonFlags = [
    "-Dapidocs=false"
    "-Ddocs=false"
    "-Dvapi=true"
  ];

  meta = with stdenv.lib; {
    description = "Software metadata handling library";
    homepage    = https://www.freedesktop.org/wiki/Distributions/AppStream/;
    longDescription = ''
      AppStream is a cross-distro effort for building Software-Center applications
      and enhancing metadata provided by software components.  It provides
      specifications for meta-information which is shipped by upstream projects and
      can be consumed by other software.
    '';
    license     = licenses.lgpl21Plus;
    platforms   = platforms.linux;
 };
}
