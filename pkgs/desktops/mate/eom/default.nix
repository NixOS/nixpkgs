{ stdenv, fetchurl, pkgconfig, intltool, itstool, dbus_glib, exempi, lcms2, libexif, libjpeg, librsvg, libxml2, shared_mime_info, gnome3, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "eom-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = "1.18";
  minor-ver = "2";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
    sha256 = "00ns7g7qykakc89lijrw2vwy9x9ijqiyvmnd4sw0j6py90zs8m87";
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
  ];

  meta = {
    description = "An image viewing and cataloging program for the MATE desktop";
    homepage = http://mate-desktop.org;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
