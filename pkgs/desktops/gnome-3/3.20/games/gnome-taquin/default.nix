{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, libcanberra_gtk3, intltool, itstool, libxml2 }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  buildInputs = [
    pkgconfig gtk3 wrapGAppsHook librsvg libcanberra_gtk3
    intltool itstool libxml2 gnome3.defaultIconTheme
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Taquin;
    description = "Move tiles so that they reach their places";
    maintainers = gnome3.maintainers;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
