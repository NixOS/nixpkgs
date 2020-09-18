{ stdenv, fetchurl, pkgconfig, gettext, itstool, exempi, lcms2, libexif, libjpeg, librsvg, libxml2, libpeas, shared-mime-info, gtk3, mate, hicolor-icon-theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "eom";
  version = "1.24.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0dralsc0dvs0l38cysdhx6kiaiqlb8qi6g9xz2cm6mjqyq3d3f9f";
  };

  nativeBuildInputs = [
    pkgconfig
    gettext
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

  enableParallelBuilding = true;

  meta = {
    description = "An image viewing and cataloging program for the MATE desktop";
    homepage = "https://mate-desktop.org";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
