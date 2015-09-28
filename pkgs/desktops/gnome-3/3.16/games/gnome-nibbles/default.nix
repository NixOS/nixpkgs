{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, libcanberra_gtk3, clutter_gtk, intltool, itstool
, libxml2 }:

stdenv.mkDerivation rec {
  name = "gnome-nibbles-${gnome3.version}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-nibbles/${gnome3.version}/${name}.tar.xz";
    sha256 = "1384hc7vx3i1jkmc1pw1cjh61jymq9441ci1k06vjz62r9as1nmx";
  };

  buildInputs = [
    pkgconfig gtk3 wrapGAppsHook intltool itstool libxml2
    librsvg libcanberra_gtk3 clutter_gtk gnome3.defaultIconTheme
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Nibbles;
    description = "Guide a worm around a maze";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
