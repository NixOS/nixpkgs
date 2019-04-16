{ stdenv, fetchurl, autoreconfHook, gtk3, mate, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  name = "mate-icon-theme-faenza-${version}";
  version = "1.20.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "000vr9cnbl2qlysf2gyg1lsjirqdzmwrnh6d3hyrsfc0r2vh4wna";
  };

  nativeBuildInputs = [ autoreconfHook gtk3 ];

  buildInputs = [ mate.mate-icon-theme hicolor-icon-theme ];

  postInstall = ''
    for theme in "$out"/share/icons/*; do
      gtk-update-icon-cache "$theme"
    done
  '';

  meta = {
    description = "Faenza icon theme from MATE";
    homepage = https://mate-desktop.org;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
