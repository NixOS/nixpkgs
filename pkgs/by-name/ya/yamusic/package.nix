{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  taglib,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yamusic";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "andfriden";
    repo = "YaMusic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C4Cd0F+jSYOfuIoed8bDYqGJJqQ7M4b0eYBdop4/J9o=";
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtmultimedia
    taglib
  ];

  cmakeFlags = [ "-DBUILD_WITH_QT_DEPLOYMENT=OFF" ];

  meta = {
    description = "Unofficial desktop client for Yandex Music";
    homepage = "https://github.com/andfriden/YaMusic";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.maxmosk ];
  };
})
