{ stdenv, fetchurl, pkgconfig, gtk3, gnome3, gdk_pixbuf, librsvg, dconf
, clutter, clutter-gtk, intltool, itstool, libxml2, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "swell-foop-${version}";
  version = "3.28.0";

  src = fetchurl {
    url = "mirror://gnome/sources/swell-foop/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1yjmg6sgi7mvp10fsqlkqshajmh8kgdmg6vyj5r8y48pv2ihfk64";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "swell-foop"; attrPath = "gnome3.swell-foop"; };
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk3 gnome3.defaultIconTheme gdk_pixbuf librsvg
                  dconf wrapGAppsHook itstool intltool clutter clutter-gtk libxml2 ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Swell%20Foop;
    description = "Puzzle game, previously known as Same GNOME";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
