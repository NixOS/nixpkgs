{ lib
, stdenv
, fetchurl
, autoreconfHook
, gtk3
, mate
, hicolor-icon-theme
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "mate-icon-theme-faenza";
  version = "1.20.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "000vr9cnbl2qlysf2gyg1lsjirqdzmwrnh6d3hyrsfc0r2vh4wna";
  };

  nativeBuildInputs = [
    autoreconfHook
    gtk3
  ];

  propagatedBuildInputs = [
    mate.mate-icon-theme
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  postInstall = ''
    for theme in "$out"/share/icons/*; do
      gtk-update-icon-cache "$theme"
    done
  '';

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript {
    inherit pname version;
    url = "https://github.com/mate-desktop-legacy-archive/mate-icon-theme-faenza";
  };

  meta = with lib; {
    description = "Faenza icon theme from MATE";
    homepage = "https://mate-desktop.org";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}
