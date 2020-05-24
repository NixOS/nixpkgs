{ stdenv, fetchFromGitHub, coreutils, gfortran7, gnused
, python27, utillinux, which, bash
}:

let
  version = "1.13";
in stdenv.mkDerivation {
  pname = "libxsmm";
  inherit version;

  src = fetchFromGitHub {
    owner = "hfp";
    repo = "libxsmm";
    rev = "refs/tags/${version}";
    sha256 = "1c15ccy7vbmvxkfnc7sn26wnf6gr6gxgkmilpgpycm1fhi8ikd6w";
  };

  buildInputs = [
    coreutils
    gfortran7
    gnused
    python27
    utillinux
    which
  ];

  prePatch = ''
    patchShebangs .
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Library targeting Intel Architecture for specialized dense and sparse matrix operations, and deep learning primitives";
    license = licenses.bsd3;
    homepage = https://github.com/hfp/libxsmm ;
    platforms = platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ chessai ];
    inherit version;
  };
}
