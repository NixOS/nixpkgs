{ stdenv, fetchurl, pkgconfig, intltool, itstool, libxml2, gnome3, mate, hicolor-icon-theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "engrampa-${version}";
  version = "1.20.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "1pk053i14a0r5s9qkipwnp4qjg76b763203z64ymnpkslrrarnnm";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    itstool
    wrapGAppsHook
  ];

  buildInputs = [
    libxml2
    gnome3.gtk
    mate.caja
    hicolor-icon-theme
    mate.mate-desktop
  ];

  configureFlags = [ "--with-cajadir=$$out/lib/caja/extensions-2.0" ];

  meta = {
    description = "Archive Manager for MATE";
    homepage = http://mate-desktop.org;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
