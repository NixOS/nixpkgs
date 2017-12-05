{ stdenv, fetchurl, autoreconfHook, mate, hicolor_icon_theme }:

stdenv.mkDerivation rec {
  name = "mate-icon-theme-faenza-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = "1.18";
  minor-ver = "1";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
    sha256 = "0vc3wg9l5yrxm0xmligz4lw2g3nqj1dz8fwv90xvym8pbjds2849";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ mate.mate-icon-theme hicolor_icon_theme ];
  
  meta = {
    description = "Faenza icon theme from MATE";
    homepage = http://mate-desktop.org;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
