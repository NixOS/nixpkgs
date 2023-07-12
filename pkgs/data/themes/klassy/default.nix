{ lib
, stdenv
, fetchFromGitHub
, wrapQtAppsHook
, cmake
, extra-cmake-modules
, frameworkintegration
, kdecoration
, kirigami2
, kcmutils
, qt5
}:

stdenv.mkDerivation rec {
  pname = "klassy";
  version = "4.3.breeze5.27.5";

  src = fetchFromGitHub {
    owner = "paulmcauley";
    repo = "klassy";
    rev = version;
    hash = "sha256-2qs30L7U5kf1Yf+4Pgsjsyaqf9iIaeuRK25Xtn47AYI=";
  };

  buildInputs = [
    frameworkintegration
    kcmutils
    kdecoration
    kirigami2
    qt5.qtx11extras
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    wrapQtAppsHook
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=$out"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DBUILD_TESTING=OFF"
    "-DKDE_INSTALL_USE_QT_SYS_PATHS=ON"
  ];

  meta = {
    description = "A highly customizable binary Window Decoration and Application Style plugin for recent versions of the KDE Plasma desktop";
    homepage = "https://github.com/paulmcauley/klassy";
    changelog = "https://github.com/paulmcauley/klassy/releases/tag/${version}";
    license = with lib.licenses; [ bsd3 cc0 fdl12Plus gpl2Only gpl2Plus gpl3Only mit ];
    maintainers = with lib.maintainers; [ taj-ny ];
  };
}
