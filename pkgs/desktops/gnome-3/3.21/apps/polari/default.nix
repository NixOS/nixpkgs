{ stdenv, intltool, fetchurl, gdk_pixbuf, adwaita-icon-theme
, telepathy_glib, gjs, itstool, telepathy_idle
, pkgconfig, gtk3, glib, librsvg, gnome3, wrapGAppsHook }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  propagatedUserEnvPkgs = [ telepathy_idle ];

  buildInputs = [ pkgconfig gtk3 glib intltool itstool adwaita-icon-theme wrapGAppsHook
                  telepathy_glib gjs gdk_pixbuf librsvg ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Polari;
    description = "IRC chat client designed to integrate with the GNOME desktop";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
