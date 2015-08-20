{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook, gjs
, libgweather, intltool, itstool }:

stdenv.mkDerivation rec {
  name = "gnome-weather-${gnome3.version}.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-weather/${gnome3.version}/${name}.tar.xz";
    sha256 = "14dx5zj9200qpsb7byfrjkw3144s0q0nmaw5c6ni7vpa8kmvbrac";
  };

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
