{ stdenv, fetchurl, pkgconfig, intltool, itstool, dbus-glib, exempi, lcms2, libexif, libjpeg, librsvg, libxml2, shared-mime-info, gnome3, mate, hicolor-icon-theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "eom-${version}";
  version = "1.21.2";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "08idw219mw0v0nkaphy0jvxi67gqm4nzbbnhnwjksxbma2gmpvss";
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
