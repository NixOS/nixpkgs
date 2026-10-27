{
  stdenv,
  lib,
  fetchFromCodeberg,
  qt6,
  udev,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ubpm";
  version = "1.13.0-unstable-2025-10-18";
  baseVersion = lib.head (lib.splitString "-" finalAttrs.version);

  src = fetchFromCodeberg {
    owner = "LazyT";
    repo = "ubpm";
    rev = "748ce8504185ae96dbdbd1cff5352d1eef2c046d";
    hash = "sha256-WSweHj4+qgjqEsn0TNtmbVXjFJD84EWkdqK44/CsqgQ=";
    fetchSubmodules = true;
  };

  sourceRoot = "${finalAttrs.src.name}/sources";

  qmakeFlags = [
    "DEFINES+=DISTRIBUTION"
    "DEFINES+=UPDATE_HIDE"
    "DEFINES+=UPDATE_DISABLE"
  ];

  postFixup = ''
    wrapQtApp $out/bin/ubpm
  '';

  nativeBuildInputs = [
    qt6.qmake
    qt6.qttools
    qt6.wrapQtAppsHook
    pkg-config
  ];

  # *.so plugins are being wrapped automatically which breaks them
  dontWrapQtApps = true;

  buildInputs = [
    qt6.qtbase
    qt6.qtserialport
    qt6.qtconnectivity
    qt6.qtcharts
    qt6.qtsvg
    udev
  ];

  meta = {
    homepage = "https://codeberg.org/LazyT/ubpm";
    changelog = "https://codeberg.org/LazyT/ubpm/releases/tag/${finalAttrs.baseVersion}";
    description = "Universal Blood Pressure Manager";
    mainProgram = "ubpm";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ kurnevsky ];
    broken = stdenv.hostPlatform.isDarwin;
  };
})
