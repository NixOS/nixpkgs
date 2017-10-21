{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, webkitgtk, intltool, gsettings_desktop_schemas }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gtk3 wrapGAppsHook webkitgtk intltool gnome3.defaultIconTheme
    gsettings_desktop_schemas
  ];

  meta = with stdenv.lib; {
    homepage = https://live.gnome.org/devhelp;
    description = "API documentation browser for GNOME";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
