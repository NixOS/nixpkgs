{ stdenv, fetchurl, pkgconfig, intltool, itstool, exempi, lcms2, libexif, libjpeg, librsvg, libxml2, libpeas, shared-mime-info, gnome3, gtk3, mate, hicolor-icon-theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "eom-${version}";
  version = "1.22.1";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "03lpxqvyaqhz4wmi07nxcyn5q73ym3dzm41cdid53f2dp9lk1mv4";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    itstool
    wrapGAppsHook
  ];

  buildInputs = [
    exempi
    lcms2
    libexif
    libjpeg
    librsvg
    libxml2
    shared-mime-info
    gtk3
    libpeas
    mate.mate-desktop
    hicolor-icon-theme
  ];

  meta = {
    description = "An image viewing and cataloging program for the MATE desktop";
    homepage = https://mate-desktop.org;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
