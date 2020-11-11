{ stdenv, fetchurl, pkgconfig, gtk3, gnome3, gdk-pixbuf
, librsvg, gsound, libmanette
, gettext, itstool, libxml2, clutter, clutter-gtk, wrapGAppsHook
, meson, ninja, python3, vala, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "quadrapassel";
  version = "3.38.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "033plabc6q3sk6qjr5nml8z6p07vcw57gxddxjk9b65wgg0rzzhr";
  };

  nativeBuildInputs = [
    meson ninja python3 vala desktop-file-utils
    pkgconfig gnome3.adwaita-icon-theme
    libxml2 itstool gettext wrapGAppsHook
  ];
  buildInputs = [
    gtk3 gdk-pixbuf librsvg libmanette
    gsound clutter libxml2 clutter-gtk
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "Classic falling-block game, Tetris";
    homepage = "https://wiki.gnome.org/Apps/Quadrapassel";
    license = licenses.gpl2;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
