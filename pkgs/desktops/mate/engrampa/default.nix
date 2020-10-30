{ stdenv, fetchurl, pkgconfig, gettext, itstool, libxml2, gtk3, file, mate, hicolor-icon-theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "engrampa";
  version = "1.24.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0akjnz85qkpiqgj1ccn41rzbfid4l3r3nsm4s9s779ilzd7f097y";
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
    file #libmagic
    mate.caja
    hicolor-icon-theme
    mate.mate-desktop
  ];

  configureFlags = [
    "--with-cajadir=$$out/lib/caja/extensions-2.0"
    "--enable-magic"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Archive Manager for MATE";
    homepage = "https://mate-desktop.org";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
