{ stdenv, fetchFromGitHub, gfortran, suitesparse, openblas }:
let
  suitesparse_ = suitesparse;
in let
  # SuiteSparse must use the same openblas
  suitesparse = suitesparse_.override { inherit openblas; };
in stdenv.mkDerivation rec {
  pname = "cholmod-extra";
  version = "1.2.0";

  src = fetchFromGitHub {
    repo = pname;
    owner = "jluttine";
    rev = version;
    sha256 = "0hz1lfp0zaarvl0dv0zgp337hyd8np41kmdpz5rr3fc6yzw7vmkg";
  };

  buildInputs = [ suitesparse gfortran openblas ];

  buildFlags = [
    "BLAS=-lopenblas"
  ];

  installFlags = [
    "INSTALL_LIB=$(out)/lib"
    "INSTALL_INCLUDE=$(out)/include"
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/jluttine/cholmod-extra;
    description = "A set of additional routines for SuiteSparse CHOLMOD Module";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ jluttine ];
    platforms = with platforms; unix;
  };

}
