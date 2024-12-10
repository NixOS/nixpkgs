{
  lib,
  stdenv,
  fetchFromGitHub,
  gfortran,
  pkg-config,
  blas,
  bzip2,
  cbc,
  clp,
  ipopt,
  lapack,
  libamplsolver,
  zlib,
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
    gfortran
    pkg-config
  ];
  buildInputs = [
    blas
    bzip2
    cbc
    clp
    ipopt
    lapack
    libamplsolver
    zlib
  ];

  meta = with lib; {
    description = "An open-source code for solving general MINLP (Mixed Integer NonLinear Programming) problems";
    mainProgram = "bonmin";
    homepage = "https://github.com/coin-or/Bonmin";
    license = licenses.epl10;
    platforms = platforms.unix;
    maintainers = with maintainers; [ aanderse ];
    # never built on aarch64-darwin, x86_64-darwin since first introduction in nixpkgs
    broken = stdenv.isDarwin;
  };
}
