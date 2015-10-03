{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, libcanberra_gtk3, intltool, itstool, libxml2 }:

stdenv.mkDerivation rec {
  name = "gnome-taquin-${gnome3.version}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-taquin/${gnome3.version}/${name}.tar.xz";
    sha256 = "024a1ing1iclmyhi5vlps6xna84vgy7s098h9yvzq43fsahmx8pi";
  };

  buildInputs = [
    pkgconfig gtk3 wrapGAppsHook librsvg libcanberra_gtk3
    intltool itstool libxml2 gnome3.defaultIconTheme
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Taquin;
    description = "Move tiles so that they reach their places";
    maintainers = gnome3.maintainers;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
