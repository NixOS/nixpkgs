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
  version = "0.1-unstable-2026-02-23";

  src = fetchFromGitHub {
    owner = "vgmrips";
    repo = "vgmtools";
    rev = "728c8c75d770632244ac387307286344c2144cd3";
    hash = "sha256-HIMOj9eWElHe/AozrM8prGNShV3gJEb8Zhd0irzELew=";
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
