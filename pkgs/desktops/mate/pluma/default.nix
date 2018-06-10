{ stdenv, fetchurl, pkgconfig, intltool, itstool, isocodes, enchant, libxml2, python, gnome3, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "pluma-${version}";
  version = "1.21.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "1y3zl0rzp069pix1vgrhzkkfc3lvhq9ahfgbmc88cwqw9aw3mgk0";
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
