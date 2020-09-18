{ stdenv, fetchurl, pkgconfig, gtk3, gnome3, gdk-pixbuf, librsvg, wrapGAppsHook
, itstool, gsound, libxml2
, meson, ninja, python3, vala, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "iagno";
  version = "3.38.0";

  src = fetchurl {
    url = "mirror://gnome/sources/iagno/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0fd7bmym35b43d2gp6ngablry85gb2j52gp4lgqd098hbn5ziaf4";
  };

  nativeBuildInputs = [
    meson ninja python3 vala desktop-file-utils
    pkgconfig wrapGAppsHook itstool libxml2
  ];
  buildInputs = [ gtk3 gnome3.adwaita-icon-theme gdk-pixbuf librsvg gsound ];

  enableParallelBuilding = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "iagno";
      attrPath = "gnome3.iagno";
    };
  };

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Apps/Iagno";
    description = "Computer version of the game Reversi, more popularly called Othello";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
