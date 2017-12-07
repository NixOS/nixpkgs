{ stdenv, fetchurl, pkgconfig, gnome3, intltool, itstool, libxml2,
  wrapGAppsHook }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];

  buildInputs = [ gnome3.gtk intltool itstool libxml2 ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Ghex;
    description = "Hex editor for GNOME desktop environment";
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
