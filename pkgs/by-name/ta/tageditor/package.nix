{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  cmake,
  cpp-utilities,
  mp4v2,
  libid3tag,
  kdePackages,
  qt6,
  tagparser,
}:

stdenv.mkDerivation rec {
  pname = "tageditor";
  version = "3.9.8";

  src = fetchFromGitHub {
    owner = "martchus";
    repo = "tageditor";
    tag = "v${version}";
    hash = "sha256-D4O02QQNoyY61w/9OB4lY3QkiwJ6q1KdX9GNKgW5ZY0=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    mp4v2
    libid3tag
    cpp-utilities
    kdePackages.qtutilities
    qt6.qtbase
    qt6.qttools
    qt6.qtwebengine
    tagparser
  ];

  cmakeFlags = [
    "-DQT_PACKAGE_PREFIX=Qt6"
    "-DQt6_DIR=${qt6.qtbase}/lib/cmake/Qt6"
    "-DQt6WebEngineWidgets_DIR=${qt6.qtwebengine}/lib/cmake/Qt6WebEngineWidgets"
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    mv $out/bin/*.app $out/Applications
    ln -s $out/Applications/tageditor.app/Contents/MacOS/tageditor $out/bin/tageditor
  '';

  meta = {
    homepage = "https://github.com/Martchus/tageditor";
    description = "Tag editor with Qt GUI and command-line interface supporting MP4/M4A/AAC (iTunes), ID3, Vorbis, Opus, FLAC and Matroska";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.matthiasbeyer ];
    platforms = lib.platforms.unix;
    mainProgram = "tageditor";
  };
}
