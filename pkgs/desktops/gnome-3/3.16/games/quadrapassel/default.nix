{ stdenv, fetchurl, pkgconfig, gtk3, gnome3, gdk_pixbuf
, librsvg, libcanberra_gtk3
, intltool, itstool, libxml2, clutter, clutter_gtk, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "quadrapassel-${gnome3.version}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/quadrapassel/${gnome3.version}/${name}.tar.xz";
    sha256 = "17c6ddjgmakj615ahnrmrzayjxc2ylr8dddfzi9py875q5vk7grx";
  };

  buildInputs = [ pkgconfig gtk3 gnome3.defaultIconTheme gdk_pixbuf librsvg
                  libcanberra_gtk3 itstool intltool clutter
                  libxml2 clutter_gtk wrapGAppsHook ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Quadrapassel;
    description = "Classic falling-block game, Tetris";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
