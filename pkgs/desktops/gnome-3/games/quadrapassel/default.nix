{ stdenv, fetchurl, pkgconfig, gtk3, gnome3, gdk_pixbuf
, librsvg, libcanberra-gtk3, libmanette
, gettext, itstool, libxml2, clutter, clutter-gtk, wrapGAppsHook
, meson, ninja, python3, vala, desktop-file-utils
}:

let
  pname = "quadrapassel";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "3.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/quadrapassel/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1zhi1957knz9dm98drn2dh95mr33sdch590yddh1f8r6bzsfjvpy";
  };

  nativeBuildInputs = [
    meson ninja python3 vala desktop-file-utils
    pkgconfig gnome3.adwaita-icon-theme
    libxml2 itstool gettext wrapGAppsHook
  ];
  buildInputs = [
    gtk3 gdk_pixbuf librsvg libmanette
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
