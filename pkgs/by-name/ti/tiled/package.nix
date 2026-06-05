{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  qbs,
  libsForQt5,
  zlib,
  zstd,
  libGL,
}:

let
  qtEnv = libsForQt5.env "tiled-qt-env" [
    libsForQt5.qtbase
    libsForQt5.qtdeclarative
    libsForQt5.qtsvg
    libsForQt5.qttools
    libsForQt5.qtwayland
  ];
in

stdenv.mkDerivation (finalAttrs: {
  pname = "tiled";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "mapeditor";
    repo = "tiled";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-7Z6ibZyfFWdsxvz6rlGOqB9toULr4h2qa2uX9QXh1uU=";
  };

  nativeBuildInputs = [
    pkg-config
    qbs
    libsForQt5.wrapQtAppsHook
  ];
  buildInputs = [
    qtEnv
    zlib
    zstd
    libGL
  ];

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  configurePhase = ''
    runHook preConfigure

    qbs setup-qt --settings-dir . ${qtEnv}/bin/qmake qtenv
    qbs config --settings-dir . defaultProfile qtenv
    qbs resolve --settings-dir . config:release qbs.installPrefix:/ projects.Tiled.installHeaders:true

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    qbs build --settings-dir . config:release

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    qbs install --settings-dir . --install-root $out config:release

    runHook postInstall
  '';

  meta = {
    description = "Free, easy to use and flexible tile map editor";
    homepage = "https://www.mapeditor.org/";
    license = with lib.licenses; [
      bsd2 # libtiled and tmxviewer
      gpl2Plus # all the rest
    ];
    maintainers = with lib.maintainers; [
      dywedir
      ryan4yin
    ];
    platforms = lib.platforms.linux;
  };
})
