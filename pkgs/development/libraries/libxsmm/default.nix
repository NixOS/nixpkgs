{ stdenv, fetchFromGitHub, coreutils, gfortran, gnused
, python3, utillinux, which

, enableStatic ? false
}:

let
  version = "1.16.1";
in stdenv.mkDerivation {
  pname = "libxsmm";
  inherit version;

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
    utillinux
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

  meta = with stdenv.lib; {
    description = "Library targeting Intel Architecture for specialized dense and sparse matrix operations, and deep learning primitives";
    license = licenses.bsd3;
    homepage = "https://github.com/hfp/libxsmm";
    platforms = platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ chessai ];
  };
}
