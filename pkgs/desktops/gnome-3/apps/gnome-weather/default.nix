{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook, gjs
, libgweather, intltool, itstool, geoclue2 }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gtk3 wrapGAppsHook gjs intltool itstool
    libgweather gnome3.defaultIconTheme geoclue2 gnome3.gsettings-desktop-schemas
  ];

  # The .service file isn't wrapped with the correct environment
  # so misses GIR files when started. By re-pointing from the gjs
  # entry point to the wrapped binary we get back to a wrapped
  # binary.
  preConfigure = ''
    substituteInPlace "data/org.gnome.Weather.Application.service.in" \
        --replace "Exec=@pkgdatadir@/@PACKAGE_NAME@.Application" \
                  "Exec=$out/bin/gnome-weather"
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Weather;
    description = "Access current weather conditions and forecasts";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
