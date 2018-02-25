{ stdenv, fetchurl, pkgconfig, gtk3, gnome3, gdk_pixbuf
, librsvg, libcanberra-gtk3
, intltool, itstool, libxml2, clutter, clutter-gtk, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "quadrapassel-${version}";
  version = "3.22.0";

  src = fetchurl {
    url = "mirror://gnome/sources/quadrapassel/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0ed44ef73c8811cbdfc3b44c8fd80eb6e2998d102d59ac324e4748f5d9dddb55";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "quadrapassel"; attrPath = "gnome3.quadrapassel"; };
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk3 gnome3.defaultIconTheme gdk_pixbuf librsvg
                  libcanberra-gtk3 itstool intltool clutter
                  libxml2 clutter-gtk wrapGAppsHook ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Quadrapassel;
    description = "Classic falling-block game, Tetris";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
