{ stdenv, fetchurl, pkgconfig, intltool, iconnamingutils, hicolor_icon_theme }:

stdenv.mkDerivation rec {
  name = "mate-icon-theme-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = "1.16";
  minor-ver = "0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
    sha256 = "1zldw22p1i76iss8car39pmfagpfxxlfk1fdhvr4x5r6gf36gv7d";
  };

  nativeBuildInputs = [ pkgconfig intltool iconnamingutils ];

  buildInputs = [ hicolor_icon_theme ];

  meta = {
    description = "Icon themes from MATE";
    homepage = "http://mate-desktop.org";
    license = stdenv.lib.licenses.lgpl3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
