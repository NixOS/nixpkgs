{ stdenv, intltool, fetchurl, pkgconfig, glib, gtk, gnome3, python, libwnck3, librsvg, polkit, itstool }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  doCheck = true;

  buildInputs = with gnome3;
    [ pkgconfig glib gtk intltool python gnome_desktop gdm dconf gnome-menus libwnck3 libgweather librsvg polkit itstool ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/GnomePanel;
    description = "Gnome Panel is a component that is part of GnomeFlashback and provides panels and default applets for the desktop.";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
