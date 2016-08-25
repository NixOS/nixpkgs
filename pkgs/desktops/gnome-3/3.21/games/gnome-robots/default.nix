{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, libcanberra_gtk3, intltool, itstool, libxml2, libgames-support
, libgee}:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  buildInputs = [
    pkgconfig gtk3 wrapGAppsHook intltool itstool librsvg libcanberra_gtk3
    libxml2 gnome3.defaultIconTheme libgames-support libgee
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Robots;
    description = "Avoid the robots and make them crash into each other";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
