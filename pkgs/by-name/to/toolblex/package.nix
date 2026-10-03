{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "toolblex";
  version = "0.17";

  src = fetchFromGitHub {
    owner = "emericg";
    repo = "toolBLEx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bDRrUm/3ZHi+L8o+2XIUyPJh5KFcsgxLC6610qdSwCY=";
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
    qt6.qtgraphs
  ];

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    description = "Bluetooth Low Energy (and Classic) device scanner and analyzer";
    homepage = "https://github.com/emericg/toolBLEx";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fgaz ];
    mainProgram = "toolBLEx";
    platforms = lib.platforms.all;
  };
})
