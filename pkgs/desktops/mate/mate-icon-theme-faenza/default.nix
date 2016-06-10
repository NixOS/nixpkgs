{ stdenv, fetchurl, autoreconfHook, mate, hicolor_icon_theme }:

stdenv.mkDerivation rec {
  name = "mate-icon-theme-faenza-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = "1.14";
  minor-ver = "0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
    sha256 = "115rbw4rbk8jqbjpbh5bfqjzsbwj5723r6cw96b1xrq1dv4gy4nr";
  };

  nativeBuildInputs = [ autoreconfHook mate.mate-common ];

  buildInputs = [ hicolor_icon_theme ];
  
  meta = {
    description = "Faenza icon theme from MATE";
    homepage = "http://mate-desktop.org";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
