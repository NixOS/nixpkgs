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
  version = "0.51.1-unstable-2025-12-29";

  src = fetchFromGitHub {
    owner = "ValleyBell";
    repo = "vgmplay-libvgm";
    rev = "41877bac91d98be221b7a4c5c9d42f0869e25389";
    hash = "sha256-5NdzeYrXgwI4avymtrZgE4qfEm+mpSa4ektY3bPj6sM=";
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
