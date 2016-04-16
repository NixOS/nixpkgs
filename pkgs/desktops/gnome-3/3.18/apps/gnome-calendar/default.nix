{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, intltool, evolution_data_server, sqlite, libxml2, libsoup
, glib, gnome_online_accounts }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib.dev}/include/gio-unix-2.0";

  buildInputs = [
    pkgconfig gtk3 wrapGAppsHook intltool evolution_data_server
    sqlite libxml2 libsoup glib gnome3.defaultIconTheme gnome_online_accounts
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Calendar;
    description = "Simple and beautiful calendar application for GNOME";
    maintainers = gnome3.maintainers;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
