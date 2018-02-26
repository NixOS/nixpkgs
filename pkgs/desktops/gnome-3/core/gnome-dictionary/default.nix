{ stdenv, fetchurl, meson, ninja, pkgconfig, desktop-file-utils, appstream-glib, libxslt
, libxml2, gettext, itstool, wrapGAppsHook, docbook_xsl, docbook_xml_dtd_43
, gnome3, gtk, glib }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  doCheck = true;

  propagatedUserEnvPkgs = [ gnome3.gnome-themes-standard ];
  propagatedBuildInputs = [ gnome3.defaultIconTheme ];

  nativeBuildInputs = [ meson ninja pkgconfig wrapGAppsHook libxml2 gettext itstool
                        desktop-file-utils appstream-glib libxslt docbook_xsl docbook_xml_dtd_43];
  buildInputs = [ gtk glib gnome3.gsettings-desktop-schemas ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Dictionary;
    description = "Dictionary is the GNOME application to look up definitions";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
