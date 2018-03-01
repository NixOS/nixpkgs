{ stdenv, fetchurl, pkgconfig, gtk3, gnome3, gdk_pixbuf, librsvg, wrapGAppsHook
, intltool, itstool, libcanberra-gtk3, libxml2, dconf }:

stdenv.mkDerivation rec {
  name = "iagno-${version}";
  version = "3.26.1";

  src = fetchurl {
    url = "mirror://gnome/sources/iagno/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "3476810d0c42aa1600484de2c111c94e0cf5247a98f071b23a0b5e3036362121";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "iagno"; attrPath = "gnome3.iagno"; };
  };

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
