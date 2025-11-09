{
  stdenv,
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  cmake,
  zlib,
}:

stdenv.mkDerivation {
  pname = "vgmtools";
  version = "0.1-unstable-2025-11-04";

  src = fetchFromGitHub {
    owner = "vgmrips";
    repo = "vgmtools";
    rev = "d5d1ba5bbe9f5bc78ea0202490a3432465d5f154";
    hash = "sha256-91smzkVY+SC5zBp0v7VkIkMCZX0vs6ivPnKTyw3ZkW4=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    zlib
  ];

  # Some targets are not enabled by default
  makeFlags = [
    "all"
    "optdac"
    "optvgm32"
  ];

  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/vgmrips/vgmtools.git";
  };

  meta = with lib; {
    homepage = "https://github.com/vgmrips/vgmtools";
    description = "Collection of tools for the VGM file format";
    license = licenses.gpl2Only; # Not clarified whether Only or Plus
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.all;
  };
}
