{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, intltool, itstool, librsvg, libxml2 }:

stdenv.mkDerivation rec {
  name = "gnome-chess-${gnome3.version}.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-chess/${gnome3.version}/${name}.tar.xz";
    sha256 = "0j1vvf1myki3bafsqv52q59qk1nhf1636nrb15fpfvm88p3b8wwg";
  };

  buildInputs = [
    pkgconfig gtk3 wrapGAppsHook intltool itstool librsvg libxml2
    gnome3.defaultIconTheme
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Chess;
    description = "Play the classic two-player boardgame of chess";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
