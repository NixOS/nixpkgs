{
  lib,
  stdenv,
  qtbase,
  qtdeclarative,
  fetchFromGitHub,
  cmake,
  pkg-config,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "qml-box2d";
  version = "0-unstable-2024-04-15";

  src = fetchFromGitHub {
    owner = "qml-box2d";
    repo = "qml-box2d";
    rev = "3a85439726d1ac4d082308feba45f23859ba71e0";
    hash = "sha256-lTgzPJWSwNfPRj5Lc63C69o4ILuyhVRLvltTo5E7yq0=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    qtbase
    qtdeclarative
  ];

  passthru = {
    updateScript = unstableGitUpdater {
      hardcodeZeroVersion = true;
    };
  };

  meta = {
    description = "QML plugin for Box2D engine";
    homepage = "https://github.com/qml-box2d/qml-box2d";
    maintainers = with lib.maintainers; [ guibou ];
    platforms = lib.platforms.linux;
    license = lib.licenses.zlib;
  };
}
