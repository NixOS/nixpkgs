{ lib, stdenv, fetchFromGitHub, coreutils, gfortran, gnused
, python3, util-linux, which

, enableStatic ? stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation rec {
  pname = "libxsmm";
  version = "1.16.1";

  src = fetchFromGitHub {
    owner = "hfp";
    repo = "libxsmm";
    rev = version;
    sha256 = "1c1qj6hcdfx11bvilnly92vgk1niisd2bjw1s8vfyi2f7ws1wnp0";
  };

  nativeBuildInputs = [
    coreutils
    gfortran
    gnused
    python3
    util-linux
    which
  ];

  enableParallelBuilding = true;

  dontConfigure = true;

  makeFlags = let
    static = if enableStatic then "1" else "0";
  in [
    "OMP=1"
    "PREFIX=$(out)"
    "STATIC=${static}"
  ];

  prePatch = ''
    patchShebangs .
  '';

  meta = with lib; {
    description = "Library targeting Intel Architecture for specialized dense and sparse matrix operations, and deep learning primitives";
    license = licenses.bsd3;
    homepage = "https://github.com/hfp/libxsmm";
    platforms = platforms.linux;
    maintainers = with lib.maintainers; [ chessai ];
  };
}
