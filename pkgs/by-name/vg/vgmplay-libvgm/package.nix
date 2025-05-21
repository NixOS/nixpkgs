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
  version = "0.51.1-unstable-2025-04-05";

  src = fetchFromGitHub {
    owner = "ValleyBell";
    repo = "vgmplay-libvgm";
    rev = "7aa3f749468e15ea6dcb94edce51315c19ee448e";
    hash = "sha256-g+nG+OdZjeHaLADQts0PcKbs3dXoBvL9qLgds+ozyRw=";
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
