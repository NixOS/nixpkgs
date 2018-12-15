{ stdenv, fetchurl, pkgconfig, gtk3, gnome3, gdk_pixbuf, librsvg, wrapGAppsHook
, intltool, itstool, libcanberra-gtk3, libxml2, dconf }:

stdenv.mkDerivation rec {
  name = "iagno-${version}";
  version = "3.30.0";

  src = fetchurl {
    url = "mirror://gnome/sources/iagno/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "15skh7186gp0k1lvzpv0l7dsr7mhb57njc3wjbgjwixym67h2d1z";
  };

  nativeBuildInputs = [ pkgconfig wrapGAppsHook itstool libxml2 ];
  buildInputs = [ gtk3 gnome3.defaultIconTheme gdk_pixbuf librsvg libcanberra-gtk3 ];

  enableParallelBuilding = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "iagno";
      attrPath = "gnome3.iagno";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Iagno;
    description = "Computer version of the game Reversi, more popularly called Othello";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
