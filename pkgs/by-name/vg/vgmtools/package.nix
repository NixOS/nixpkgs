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
  version = "0.1-unstable-2025-10-22";

  src = fetchFromGitHub {
    owner = "vgmrips";
    repo = "vgmtools";
    rev = "606db7fa229389b80bccb4c6e28b3d71dfddc984";
    hash = "sha256-kOkBIN1/FG6snpriLiu8ZMqGa2MXOC79zUZwGrMyk/A=";
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
