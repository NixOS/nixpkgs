{ stdenv, fetchurl, pkgconfig, intltool, itstool, dbus_glib, exempi, lcms2, libexif, libjpeg, librsvg, libxml2, shared_mime_info, gnome3, mate, hicolor_icon_theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "eom-${version}";
  version = "1.20.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "0320ph6cyh0m4cfyvky10j9prk2hry6rpm4jzgcn7ig03dnj4y0s";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    itstool
    wrapGAppsHook
  ];

  buildInputs = [
    dbus_glib
    exempi
    lcms2
    libexif
    libjpeg
    librsvg
    libxml2
    shared_mime_info
    gnome3.gtk
    gnome3.libpeas
    mate.mate-desktop
    hicolor_icon_theme
  ];

  meta = {
    description = "An image viewing and cataloging program for the MATE desktop";
    homepage = http://mate-desktop.org;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
