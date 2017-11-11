{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, intltool, itstool, libxml2, libgames-support, libgee }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gtk3 wrapGAppsHook librsvg intltool itstool libxml2
    gnome3.defaultIconTheme libgames-support libgee
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Mines;
    description = "Clear hidden mines from a minefield";
    maintainers = gnome3.maintainers;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
