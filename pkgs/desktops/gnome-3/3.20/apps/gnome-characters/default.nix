{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, intltool, gjs, gdk_pixbuf, librsvg }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  buildInputs = [
    pkgconfig gtk3 wrapGAppsHook intltool gjs gdk_pixbuf
    librsvg gnome3.defaultIconTheme
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Design/Apps/CharacterMap;
    description = "Simple utility application to find and insert unusual characters";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
