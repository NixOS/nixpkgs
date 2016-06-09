{ stdenv, fetchurl, vala, libxslt, pkgconfig, glib, dbus_glib, gnome3
, libxml2, intltool, docbook_xsl_ns, docbook_xsl, wrapGAppsHook }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];

  buildInputs = [ vala libxslt glib dbus_glib gnome3.gtk libxml2 gnome3.defaultIconTheme
                  intltool docbook_xsl docbook_xsl_ns gnome3.dconf ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
