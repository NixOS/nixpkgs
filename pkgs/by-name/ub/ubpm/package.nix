{
  stdenv,
  lib,
  fetchFromGitea,
  libsForQt5,
  udev,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ubpm";
  version = "1.13.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "LazyT";
    repo = "ubpm";
    rev = finalAttrs.version;
    hash = "sha256-lS9SVWTk7Obr3g9YsqJcEL+4dxzTQ+Z98C3lFEsn3Tw=";
    fetchSubmodules = true;
  };

  sourceRoot = "${finalAttrs.src.name}/sources";

  postFixup = ''
    wrapQtApp $out/bin/ubpm
  '';

  nativeBuildInputs = [
    libsForQt5.qmake
    libsForQt5.qttools
    libsForQt5.wrapQtAppsHook
    pkg-config
  ];

  # *.so plugins are being wrapped automatically which breaks them
  dontWrapQtApps = true;

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qtserialport
    libsForQt5.qtconnectivity
    libsForQt5.qtcharts
    udev
  ];

  meta = {
    homepage = "https://codeberg.org/LazyT/ubpm";
    changelog = "https://codeberg.org/LazyT/ubpm/releases/tag/${finalAttrs.version}";
    description = "Universal Blood Pressure Manager";
    mainProgram = "ubpm";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ kurnevsky ];
    broken = stdenv.hostPlatform.isDarwin;
  };
})
