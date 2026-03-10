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
  version = "0.1-unstable-2026-02-26";

  src = fetchFromGitHub {
    owner = "vgmrips";
    repo = "vgmtools";
    rev = "9962da3be999da57e0ea09e0deb1a479524e499f";
    hash = "sha256-6P7i/BT+v26SvJtj/FH70XKwuTfp8PtSAChvHFY6aLw=";
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
