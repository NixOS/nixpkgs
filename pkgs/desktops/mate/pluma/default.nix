{ stdenv, fetchurl, pkgconfig, intltool, itstool, isocodes, enchant, libxml2, python, gnome3, gtksourceview3, libpeas, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "pluma-${version}";
  version = "1.20.4";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "0qdbm5y6q8lbabd81mg3rnls5bdvbmfii82f6syqw1cw6381mzgz";
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
    python
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
