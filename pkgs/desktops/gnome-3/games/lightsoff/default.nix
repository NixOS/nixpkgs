{ stdenv, fetchurl, pkgconfig, gtk3, gnome3, gdk_pixbuf, librsvg, wrapGAppsHook
, intltool, itstool, clutter, clutter-gtk, libxml2, dconf }:

stdenv.mkDerivation rec {
  name = "lightsoff-${version}";
  version = "3.28.0";

  src = fetchurl {
    url = "mirror://gnome/sources/lightsoff/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0rwh9kz6aphglp79cyrfjab6vy02vclq68f646zjgb9xgg6ar73g";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "lightsoff"; attrPath = "gnome3.lightsoff"; };
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk3 gnome3.defaultIconTheme gdk_pixbuf librsvg dconf
                  libxml2 clutter clutter-gtk wrapGAppsHook itstool intltool ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Lightsoff;
    description = "Puzzle game, where the objective is to turn off all of the tiles on the board";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
