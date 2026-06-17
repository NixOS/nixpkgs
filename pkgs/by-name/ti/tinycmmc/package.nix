{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation {
  pname = "tinycmmc";
  version = "0.1.0-unstable-2025-07-21";

  src = fetchFromGitHub {
    owner = "Grumbel";
    repo = "tinycmmc";
    rev = "caf1af301e388e97dca31ee7fdc12f17cff34f82";
    sha256 = "sha256-62ykvAIfOCXH+3bF1IkR+WukeJBLcYC/4Mv3ptqAxEM=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Tiny CMake Module Collections";
    maintainers = [ lib.maintainers.SchweGELBin ];
    platforms = lib.platforms.linux;
    license = lib.licenses.zlib;
  };
}
