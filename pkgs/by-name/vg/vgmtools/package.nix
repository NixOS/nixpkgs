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
  version = "0.1-unstable-2026-08-16";

  src = fetchFromGitHub {
    owner = "vgmrips";
    repo = "vgmtools";
    rev = "f60cdc3da1828a11debb289def9a7001fa32a8c6";
    hash = "sha256-PDksslME/hkeMDZBnW9kNi0uDAQaPntjNu39pNVHOe4=";
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

  meta = {
    homepage = "https://github.com/vgmrips/vgmtools";
    description = "Collection of tools for the VGM file format";
    license = lib.licenses.gpl2Only; # Not clarified whether Only or Plus
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = lib.platforms.all;
  };
}
