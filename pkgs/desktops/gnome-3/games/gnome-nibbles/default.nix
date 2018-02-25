{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, libcanberra-gtk3, clutter-gtk, intltool, itstool
, libxml2, libgee, libgames-support }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gtk3 wrapGAppsHook intltool itstool libxml2
    librsvg libcanberra-gtk3 clutter-gtk gnome3.defaultIconTheme
    libgee libgames-support
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Nibbles;
    description = "Guide a worm around a maze";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
