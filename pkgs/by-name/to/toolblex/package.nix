{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
}:

stdenv.mkDerivation {
  pname = "toolblex";
  version = "0.9-unstable-2025-10-31";

  src = fetchFromGitHub {
    owner = "emericg";
    repo = "toolBLEx";
    rev = "4f0bf98bb1f30ee4cfebc6ffc35c8a4286688560";
    hash = "sha256-5YMRaqy/ne4jyFRyfM2ydFmKI7gZdoZZkHCQa3KBwB0=";
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
}
