{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook, gjs
, libgweather, intltool, itstool }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  buildInputs = [
    pkgconfig gtk3 wrapGAppsHook gjs intltool itstool
    libgweather gnome3.defaultIconTheme
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Weather;
    description = "Access current weather conditions and forecasts";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
