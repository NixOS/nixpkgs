{ stdenv, fetchurl, pkgconfig, intltool, itstool, isocodes, enchant, libxml2, python3, gnome3, gtksourceview3, libpeas, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "pluma";
  version = "1.22.2";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1gsj8grdhzb1jvl5zwd8zjc9cj9ys2ndny04gy4bbh80sjaj6xva";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    itstool
    isocodes
    wrapGAppsHook
  ];

  buildInputs = [
    enchant
    libxml2
    python3
    gtksourceview3
    libpeas
    gnome3.adwaita-icon-theme
    mate.mate-desktop
  ];

  meta = {
    description = "Powerful text editor for the MATE desktop";
    homepage = https://mate-desktop.org;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
