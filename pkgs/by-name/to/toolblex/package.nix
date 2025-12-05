{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "toolblex";
  version = "0.14";

  src = fetchFromGitHub {
    owner = "emericg";
    repo = "toolBLEx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MtyRHkJ+IyjO8FcdjbUfSxSNU53vjTfjs/o5Q9GitL0=";
  };

  nativeBuildInputs = [
    cmake
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtcharts
    qt6.qtconnectivity
  ];

  meta = {
    description = "Bluetooth Low Energy (and Classic) device scanner and analyzer";
    homepage = "https://github.com/emericg/toolBLEx";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fgaz ];
    mainProgram = "toolBLEx";
    platforms = lib.platforms.all;
  };
})
