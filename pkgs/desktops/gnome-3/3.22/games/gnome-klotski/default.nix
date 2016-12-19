{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, libxml2, intltool, itstool, libgee, libgames-support }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  buildInputs = [
    pkgconfig gtk3 wrapGAppsHook intltool itstool librsvg libxml2 libgee libgames-support
    gnome3.defaultIconTheme
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Klotski;
    description = "Slide blocks to solve the puzzle";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
