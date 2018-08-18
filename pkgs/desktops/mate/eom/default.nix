{ stdenv, fetchurl, pkgconfig, intltool, itstool, dbus-glib, exempi, lcms2, libexif, libjpeg, librsvg, libxml2, shared-mime-info, gnome3, mate, hicolor-icon-theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "eom-${version}";
  version = "1.21.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "165n314hxapq8glzlv7vs5x44z13wjmpysl5p7q3ckrsxy5pczww";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    itstool
    wrapGAppsHook
  ];

  buildInputs = [
    dbus-glib
    exempi
    lcms2
    libexif
    libjpeg
    librsvg
    libxml2
    shared-mime-info
    gnome3.gtk
    gnome3.libpeas
    mate.mate-desktop
    hicolor-icon-theme
  ];

  meta = {
    description = "An image viewing and cataloging program for the MATE desktop";
    homepage = http://mate-desktop.org;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
