{ stdenv, fetchurl, pkgconfig, gettext, itstool, libxml2, gtk3, mate, hicolor-icon-theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "engrampa";
  version = "1.24.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "13cak3qgrzqj74x9jq1sf155793v2bqqz4mk4i04g9f9xn3g85fl";
  };

  nativeBuildInputs = [
    pkgconfig
    gettext
    itstool
    wrapGAppsHook
  ];

  buildInputs = [
    libxml2
    gtk3
    mate.caja
    hicolor-icon-theme
    mate.mate-desktop
  ];

  configureFlags = [ "--with-cajadir=$$out/lib/caja/extensions-2.0" ];

  enableParallelBuilding = true;

  meta = {
    description = "Archive Manager for MATE";
    homepage = "https://mate-desktop.org";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
