{ stdenv, fetchurl, pkgconfig, intltool, itstool, dbus_glib, exempi, lcms2, libexif, libjpeg, librsvg, libxml2, shared_mime_info, gnome3, mate, hicolor_icon_theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "eom-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = "1.18";
  minor-ver = "3";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
    sha256 = "1zr85ilv0f4x8iky002qvh00qhsq1vsfm5z1954gf31hi57z2j25";
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
