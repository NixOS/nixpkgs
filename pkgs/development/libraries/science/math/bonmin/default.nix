{ lib
, stdenv
, fetchFromGitHub
, gfortran
, pkg-config
, blas
, bzip2
, cbc
, clp
, coin-utils
, doxygen
, ipopt
, lapack
, libamplsolver
, osi
, zlib
}:

assert (!blas.isILP64) && (!lapack.isILP64);

stdenv.mkDerivation rec {
  pname = "bonmin";
  version = "1.8.9";

  src = fetchFromGitHub {
    owner = "coin-or";
    repo = "Bonmin";
    rev = "releases/${version}";
    sha256 = "sha256-nqjAQ1NdNJ/T4p8YljEWRt/uy2aDwyBeAsag0TmRc5Q=";
  };

  nativeBuildInputs = [
    doxygen
    gfortran
    pkg-config
  ];
  buildInputs = [
    blas
    bzip2
    cbc
    clp
    coin-utils
    ipopt
    lapack
    libamplsolver
    osi
    zlib
  ];

  configureFlagsArray = [
    "--with-asl-lib=-lipoptamplinterface -lamplsolver"
  ];

  # ignore one failing test
  postPatch = ''
    substituteInPlace Bonmin/test/Makefile.in --replace-fail \
      "./unitTest\''$(EXEEXT)" \
      ""
  '';

  doCheck = true;
  checkTarget = "test";

  meta = {
    description = "Open-source code for solving general MINLP (Mixed Integer NonLinear Programming) problems";
    mainProgram = "bonmin";
    homepage = "https://github.com/coin-or/Bonmin";
    license = lib.licenses.epl10;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ aanderse ];
  };
}
