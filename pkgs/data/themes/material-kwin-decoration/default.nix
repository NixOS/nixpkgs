{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, extra-cmake-modules
, qtx11extras
, kcoreaddons
, kguiaddons
, kconfig
, kdecoration
, kconfigwidgets
, kwindowsystem
, kiconthemes
, kwayland
, unstableGitUpdater
}:

mkDerivation rec {
  pname = "material-kwin-decoration";
  version = "unstable-2022-01-19";

  src = fetchFromGitHub {
    owner = "Zren";
    repo = "material-decoration";
    rev = "973949761f609f9c676c5b2b7c6d9560661d34c3";
    sha256 = "sha256-n+yUmBUrkS+06qLnzl2P6CTQZZbDtJLy+2mDPCcQz9M=";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules ];

  buildInputs = [
    qtx11extras
    kcoreaddons
    kguiaddons
    kdecoration
    kconfig
    kconfigwidgets
    kwindowsystem
    kiconthemes
    kwayland
  ];

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = with lib; {
    description = "Material-ish window decoration theme for KWin";
    homepage = "https://github.com/Zren/material-decoration";
    license = licenses.gpl2;
    maintainers = with maintainers; [ nickcao ];
  };
}
