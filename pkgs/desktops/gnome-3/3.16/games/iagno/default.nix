{ stdenv, fetchurl, pkgconfig, gtk3, gnome3, gdk_pixbuf, librsvg, wrapGAppsHook
, intltool, itstool, libcanberra_gtk3, libxml2, dconf }:

stdenv.mkDerivation rec {
  name = "iagno-${gnome3.version}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/iagno/${gnome3.version}/${name}.tar.xz";
    sha256 = "0pg4sx277idfab3qxxn8c7r6gpdsdw5br0x7fxhxqascvvx8my1k";
  };

  buildInputs = [ pkgconfig gtk3 gnome3.defaultIconTheme gdk_pixbuf librsvg
                  dconf libxml2 libcanberra_gtk3 wrapGAppsHook itstool intltool ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Iagno;
    description = "Computer version of the game Reversi, more popularly called Othello";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
