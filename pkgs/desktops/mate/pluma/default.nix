{ stdenv, fetchurl, pkgconfig, intltool, itstool, isocodes, enchant, libxml2, python, gnome3, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "pluma-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = "1.18";
  minor-ver = "3";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
    sha256 = "1bz2jvjfz761hcvhcbkz8sc4xf0iyixh5w0k7bx69qkwwdc0gxi0";
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
