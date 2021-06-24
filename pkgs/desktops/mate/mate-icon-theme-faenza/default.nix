{ lib, stdenv, fetchurl, autoreconfHook, gtk3, mate, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  pname = "mate-icon-theme-faenza";
  version = "1.20.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "000vr9cnbl2qlysf2gyg1lsjirqdzmwrnh6d3hyrsfc0r2vh4wna";
  };

  nativeBuildInputs = [ autoreconfHook gtk3 ];

  propagatedBuildInputs = [ mate.mate-icon-theme hicolor-icon-theme ];

  dontDropIconThemeCache = true;

  postInstall = ''
    for theme in "$out"/share/icons/*; do
      gtk-update-icon-cache "$theme"
    done
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Faenza icon theme from MATE";
    homepage = "https://mate-desktop.org";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.romildo ];
  };
}
