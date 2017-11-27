{ stdenv, meson, ninja, gettext, fetchurl, pkgconfig, glib
, evolution_data_server, evolution, sqlite
, wrapGAppsHook, itstool, desktop_file_utils
, clutter_gtk, libuuid, webkitgtk, zeitgeist
, gnome3, librsvg, gdk_pixbuf, libxml2 }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  doCheck = true;
  checkPhase = "meson test";

  patches = [
    ./no-update-icon-cache.patch
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  nativeBuildInputs = [
    meson ninja pkgconfig gettext itstool libxml2 desktop_file_utils wrapGAppsHook
  ];
  buildInputs = [ glib clutter_gtk libuuid webkitgtk gnome3.tracker
                  gnome3.gnome_online_accounts zeitgeist
                  gnome3.gsettings_desktop_schemas
                  gdk_pixbuf gnome3.defaultIconTheme librsvg
                  evolution_data_server evolution sqlite ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Bijiben;
    description = "Note editor designed to remain simple to use";
    broken = true;
    maintainers = gnome3.maintainers;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
