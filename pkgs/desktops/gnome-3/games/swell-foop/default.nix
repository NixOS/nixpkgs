{ stdenv, fetchurl, pkgconfig, gtk3, gnome3, gdk_pixbuf, librsvg, dconf
, clutter, clutter-gtk, intltool, itstool, libxml2, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "swell-foop-${version}";
  version = "3.26.0";

  src = fetchurl {
    url = "mirror://gnome/sources/swell-foop/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "122e2b5a51ad0144ea6b5fd2736ac43b101c7892198948e697bfc4c014bbba22";
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
