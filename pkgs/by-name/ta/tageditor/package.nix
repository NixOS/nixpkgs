{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  cmake,
  cpp-utilities,
  mp4v2,
  libid3tag,
  libsForQt5,
  qt5,
  tagparser,
}:

stdenv.mkDerivation rec {
  pname = "tageditor";
  version = "3.9.5";

  src = fetchFromGitHub {
    owner = "martchus";
    repo = "tageditor";
    tag = "v${version}";
    hash = "sha256-Sia6Y/V81WQj4oWjZAAR4o3TngfWq7sWxxiKEuFjQ2M=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    mp4v2
    libid3tag
    qt5.qtbase
    qt5.qttools
    qt5.qtx11extras
    qt5.qtwebengine
    cpp-utilities
    libsForQt5.qtutilities
    tagparser
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
