{
  stdenv,
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  cmake,
  pkg-config,
  zlib,
  libvgm,
  inih,
}:

stdenv.mkDerivation {
  pname = "vgmplay-libvgm";
  version = "0.51.1-unstable-2025-11-15";

  src = fetchFromGitHub {
    owner = "ValleyBell";
    repo = "vgmplay-libvgm";
    rev = "5b2e6b7d978d2de060b4840929e64c5bb239bfe2";
    hash = "sha256-wgi1PofdPG5JU4cYrTw7mIJKT8gxy6PTKBbiTd7wlpQ=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    zlib
    libvgm
    inih
  ];

  postInstall = ''
    install -Dm644 ../VGMPlay.ini $out/share/vgmplay/VGMPlay.ini
  '';

  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/ValleyBell/vgmplay-libvgm.git";
  };

  meta = with lib; {
    mainProgram = "vgmplay";
    homepage = "https://github.com/ValleyBell/vgmplay-libvgm";
    description = "New VGMPlay, based on libvgm";
    license = licenses.unfree; # no licensing text anywhere yet
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.all;
  };
}
