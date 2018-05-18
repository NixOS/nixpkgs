{ stdenv, fetchurl, vala, pkgconfig, gtk3, gnome3, gdk_pixbuf, librsvg, wrapGAppsHook
, gettext, itstool, clutter, clutter-gtk, libxml2, appstream-glib }:

stdenv.mkDerivation rec {
  name = "lightsoff-${version}";
  version = "3.28.0";

  src = fetchurl {
    url = "mirror://gnome/sources/lightsoff/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0rwh9kz6aphglp79cyrfjab6vy02vclq68f646zjgb9xgg6ar73g";
  };

  nativeBuildInputs = [ vala pkgconfig wrapGAppsHook itstool gettext appstream-glib libxml2];
  buildInputs = [ gtk3 gnome3.defaultIconTheme gdk_pixbuf librsvg clutter clutter-gtk ];

  enableParallelBuilding = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "lightsoff";
      attrPath = "gnome3.lightsoff";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Lightsoff;
    description = "Puzzle game, where the objective is to turn off all of the tiles on the board";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
