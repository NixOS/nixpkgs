{ stdenv, fetchurl, meson, ninja, pkgconfig, wrapGAppsHook
, gettext, libxml2, gnome3, gtk, evolution_data_server, libsoup
, glib, gnome_online_accounts, gsettings_desktop_schemas }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib.dev}/include/gio-unix-2.0";

  nativeBuildInputs = [ meson ninja pkgconfig gettext libxml2 wrapGAppsHook ];
  buildInputs = [
    gtk evolution_data_server libsoup glib gnome_online_accounts
    gsettings_desktop_schemas gnome3.defaultIconTheme
  ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Calendar;
    description = "Simple and beautiful calendar application for GNOME";
    maintainers = gnome3.maintainers;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
