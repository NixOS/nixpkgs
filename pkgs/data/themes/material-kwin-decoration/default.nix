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
  version = "unstable-2023-01-15";

  src = fetchFromGitHub {
    owner = "Zren";
    repo = "material-decoration";
    rev = "0e989e5b815b64ee5bca989f983da68fa5556644";
    sha256 = "sha256-Ncn5jxkuN4ZBWihfycdQwpJ0j4sRpBGMCl6RNiH4mXg=";
  };

  # Remove -Werror since it uses deprecated methods
  postPatch = ''
    substituteInPlace ./CMakeLists.txt \
      --replace "add_definitions (-Wall -Werror)" "add_definitions (-Wall)"
  '';

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
