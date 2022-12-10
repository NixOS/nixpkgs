{ lib
, stdenv
, fetchFromGitHub
, gfortran
, pkg-config
, blas
, bzip2
, cbc
, clp
, ipopt
, lapack
, libamplsolver
, zlib
}:

assert (!blas.isILP64) && (!lapack.isILP64);

stdenv.mkDerivation rec {
  pname = "bonmin";
  version = "1.8.8";

  src = fetchFromGitHub {
    owner = "coin-or";
    repo = "Bonmin";
    rev = "releases/${version}";
    sha256 = "sha256-HU25WjvG01oL3U1wG6ivTcYaN51MMxgLdKZ3AkDNe2Y=";
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
    homepage = "https://github.com/coin-or/Bonmin";
    license = licenses.epl10;
    platforms = platforms.unix;
    maintainers = with maintainers; [ aanderse ];
  };
}
