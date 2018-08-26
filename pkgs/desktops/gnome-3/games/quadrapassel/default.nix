{ stdenv, fetchurl, pkgconfig, gtk3, gnome3, gdk_pixbuf
, librsvg, libcanberra-gtk3
, intltool, itstool, libxml2, clutter, clutter-gtk, wrapGAppsHook }:

let
  pname = "quadrapassel";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "3.22.0";

  src = fetchurl {
    url = "mirror://gnome/sources/quadrapassel/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0ed44ef73c8811cbdfc3b44c8fd80eb6e2998d102d59ac324e4748f5d9dddb55";
  };

  nativeBuildInputs = [ pkgconfig itstool intltool wrapGAppsHook ];
  buildInputs = [
    gtk3 gnome3.defaultIconTheme gdk_pixbuf librsvg
    libcanberra-gtk3 clutter libxml2 clutter-gtk
  ];

  enableParallelBuilding = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "Classic falling-block game, Tetris";
    homepage = https://wiki.gnome.org/Apps/Quadrapassel;
    license = licenses.gpl2;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
