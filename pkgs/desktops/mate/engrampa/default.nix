{ stdenv, fetchurl, pkgconfig, intltool, itstool, libxml2, gtk3, mate, hicolor-icon-theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "engrampa";
  version = "1.22.3";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "17pn1qgr1a13jxv50qcnzqcw8gr96g7jz2z2y1wbwy7i44bknv6n";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
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

  meta = {
    description = "Archive Manager for MATE";
    homepage = https://mate-desktop.org;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
