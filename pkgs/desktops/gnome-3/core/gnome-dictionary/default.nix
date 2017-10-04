{ stdenv, fetchurl, meson, ninja, pkgconfig, desktop_file_utils, appstream-glib, libxslt
, libxml2, gettext, itstool, wrapGAppsHook, docbook_xsl, docbook_xml_dtd_43
, gnome3, gtk, glib }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  doCheck = true;

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];
  propagatedBuildInputs = [ gnome3.defaultIconTheme ];

  nativeBuildInputs = [ meson ninja pkgconfig wrapGAppsHook libxml2 gettext itstool
                        desktop_file_utils appstream-glib libxslt docbook_xsl ];
  buildInputs = [ gtk glib gnome3.gsettings_desktop_schemas ];

  postPatch = ''
    substituteInPlace data/meson.build --replace \
      "http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl" \
      "${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl"

    substituteInPlace data/gnome-dictionary.xml --replace \
      http://www.oasis-open.org/docbook/xml/4.3/docbookx.dtd \
      ${docbook_xml_dtd_43}/xml/dtd/docbook/docbookx.dtd
  '';

  checkPhase = "meson test";

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Dictionary;
    description = "Dictionary is the GNOME application to look up definitions";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
