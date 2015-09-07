{ stdenv, fetchurl, pkgconfig, gtk3, gnome3, gdk_pixbuf, librsvg, wrapGAppsHook
, intltool, itstool, clutter, clutter_gtk, libxml2, dconf }:

stdenv.mkDerivation rec {
  name = "lightsoff-${gnome3.version}.1.1";

  src = fetchurl {
    url = "mirror://gnome/sources/lightsoff/${gnome3.version}/${name}.tar.xz";
    sha256 = "00a2jv7wr6fxrzk7avwa0wspz429ad7ri7v95jv31nqn5q73y4c0";
  };

  buildInputs = [ pkgconfig gtk3 gnome3.defaultIconTheme gdk_pixbuf librsvg dconf
                  libxml2 clutter clutter_gtk wrapGAppsHook itstool intltool ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Lightsoff;
    description = "Puzzle game, where the objective is to turn off all of the tiles on the board";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
