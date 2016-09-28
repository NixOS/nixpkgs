{ stdenv, fetchurl, autoreconfHook, mate, hicolor_icon_theme }:

stdenv.mkDerivation rec {
  name = "mate-icon-theme-faenza-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = "1.16";
  minor-ver = "0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
    sha256 = "0p3z3qarbvrhzj2sdw3f8dp0c7wwjkk9a749bq8rh5gm9m66hibg";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ mate.mate-icon-theme hicolor_icon_theme ];
  
  meta = {
    description = "Faenza icon theme from MATE";
    homepage = "http://mate-desktop.org";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
