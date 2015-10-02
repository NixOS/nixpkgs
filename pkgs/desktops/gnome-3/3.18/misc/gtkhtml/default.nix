{ stdenv, fetchurl, pkgconfig, gtk3, intltool
, gnome3, enchant, isocodes }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  buildInputs = [ pkgconfig gtk3 intltool gnome3.adwaita-icon-theme
                  gnome3.gsettings_desktop_schemas ];

  propagatedBuildInputs = [ enchant isocodes ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
