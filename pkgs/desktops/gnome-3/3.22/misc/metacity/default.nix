{ stdenv, intltool, fetchurl, pkgconfig, glib, gtk, gnome3, libcanberra_gtk3, libstartup_notification, libgtop, gettext }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  doCheck = true;

  buildInputs = with gnome3;
    [ pkgconfig glib gtk gsettings_desktop_schemas libcanberra_gtk3 zenity libstartup_notification libgtop gettext ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/Metacity;
    description = "Metacity is the Gtk+3-based window manager used in Gnome Flashback.";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
