{ stdenv, fetchurl, pkgconfig, intltool, itstool, isocodes, enchant, libxml2, python, gnome3, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "pluma-${version}";
  version = "1.21.1";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "0sc69bz0h3f4cpgkyda9fnpjfkvbc20ldh6v3jj8fd3n460bc8ai";
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
    gnome3.gtksourceview
    gnome3.libpeas
    gnome3.defaultIconTheme
    mate.mate-desktop
  ];

  meta = {
    description = "Powerful text editor for the MATE desktop";
    homepage = http://mate-desktop.org;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
