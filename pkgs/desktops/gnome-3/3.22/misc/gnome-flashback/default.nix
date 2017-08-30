{ stdenv, intltool, fetchurl, pkgconfig, glib, gtk, gnome3, upower, ibus, xkeyboard_config, libxkbfile, polkit, libpulseaudio, libcanberra_gtk3, gettext }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  doCheck = true;

  buildInputs = with gnome3;
    [ pkgconfig glib gtk gsettings_desktop_schemas gettext
      gnome-bluetooth gnome_desktop upower ibus xkeyboard_config libxkbfile polkit libpulseaudio
      libcanberra_gtk3 ];

  propagatedBuildInputs = with gnome3;
    [ gnome_settings_daemon gnome_session gnome-panel metacity ];

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib.dev}/include/gio-unix-2.0";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/GnomeFlashback;
    description = "GNOME 2.x-like session for GNOME 3";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
