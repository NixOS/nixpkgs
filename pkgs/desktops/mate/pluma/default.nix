{ stdenv, fetchurl, pkgconfig, intltool, itstool, isocodes, enchant, libxml2, python3, gnome3, gtksourceview3, libpeas, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "pluma-${version}";
  version = "1.22.1";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "14d5c5fg31d7br9h1y3gdcr53j4sxlgybf326jvdcw8mgy91k3dg";
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
