{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "toolblex";
  version = "0.15";

  src = fetchFromGitHub {
    owner = "emericg";
    repo = "toolBLEx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ewkLBbPrI4NYaJJb97GaJaX1VRbf8Vi+UW6cPUkb8gw=";
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
