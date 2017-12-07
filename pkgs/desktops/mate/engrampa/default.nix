{ stdenv, fetchurl, pkgconfig, intltool, itstool, libxml2, gnome3, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "engrampa-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = "1.18";
  minor-ver = "2";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
    sha256 = "0d98zhqqc7qdnxcf0195kd04xmhijc0w2qrn6q61zd0daiswnv98";
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
