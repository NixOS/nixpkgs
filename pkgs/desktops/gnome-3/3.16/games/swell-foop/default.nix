{ stdenv, fetchurl, pkgconfig, gtk3, gnome3, gdk_pixbuf, librsvg, dconf
, clutter, clutter_gtk, intltool, itstool, libxml2, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "swell-foop-${gnome3.version}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/swell-foop/${gnome3.version}/${name}.tar.xz";
    sha256 = "0bhjmjcjsqdb89shs0ygi6ps5hb3lk8nhrbjnsjk4clfqbw0jzwf";
  };

  buildInputs = [ pkgconfig gtk3 gnome3.defaultIconTheme gdk_pixbuf librsvg
                  dconf wrapGAppsHook itstool intltool clutter clutter_gtk libxml2 ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Apps/Swell%20Foop";
    description = "Puzzle game, previously known as Same GNOME";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
