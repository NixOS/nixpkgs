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
  version = "0.52.0-unstable-2026-01-31";

  src = fetchFromGitHub {
    owner = "ValleyBell";
    repo = "vgmplay-libvgm";
    rev = "2a8f3909bcfca4c595ca71c0f762ff495a29e130";
    hash = "sha256-TJUhE4te/nZOsckgMksWcqawsWR8r3OInJoVrv+NVAQ=";
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

  # https://github.com/ValleyBell/vgmplay-libvgm/issues/9
  # Leftover that's still in use, missing documentation & integration into CMake script rn
  env.NIX_CFLAGS_COMPILE = "-DSHARE_PREFIX=\"${placeholder "out"}\"";

  postInstall = ''
    install -Dm644 ../VGMPlay.ini $out/share/vgmplay/VGMPlay.ini
  '';

  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/ValleyBell/vgmplay-libvgm.git";
  };

  meta = {
    mainProgram = "vgmplay";
    homepage = "https://github.com/ValleyBell/vgmplay-libvgm";
    description = "New VGMPlay, based on libvgm";
    license = lib.licenses.unfree; # no licensing text anywhere yet
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = lib.platforms.all;
  };
}
