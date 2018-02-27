{ stdenv, fetchurl, pkgconfig, gtk3, gnome3, gdk_pixbuf, librsvg, wrapGAppsHook
, intltool, itstool, libcanberra-gtk3, libxml2, dconf }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk3 gnome3.defaultIconTheme gdk_pixbuf librsvg
                  dconf libxml2 libcanberra-gtk3 wrapGAppsHook itstool intltool ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Iagno;
    description = "Computer version of the game Reversi, more popularly called Othello";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
