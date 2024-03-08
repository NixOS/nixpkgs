{ lib, stdenv, fetchFromGitHub, gfortran, suitesparse, blas, lapack }:
stdenv.mkDerivation rec {
  pname = "cholmod-extra";
  version = "1.2.0";

  src = fetchFromGitHub {
    repo = pname;
    owner = "jluttine";
    rev = version;
    sha256 = "0hz1lfp0zaarvl0dv0zgp337hyd8np41kmdpz5rr3fc6yzw7vmkg";
  };

  nativeBuildInputs = [ gfortran ];
  buildInputs = [ suitesparse blas lapack ];

  makeFlags = [
    "BLAS=-lcblas"
  ];

  installFlags = [
    "INSTALL_LIB=$(out)/lib"
    "INSTALL_INCLUDE=$(out)/include"
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/jluttine/cholmod-extra";
    description = "A set of additional routines for SuiteSparse CHOLMOD Module";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ jluttine ];
    platforms = with platforms; unix;
  };

}
