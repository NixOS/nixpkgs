{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, blas
, lapack
, gfortran
, enableAMPL ? true, libamplsolver
}:

assert (!blas.isILP64) && (!lapack.isILP64);

stdenv.mkDerivation rec {
  pname = "ipopt";
  version = "3.14.12";

  src = fetchFromGitHub {
    owner = "coin-or";
    repo = "Ipopt";
    rev = "releases/${version}";
    sha256 = "sha256-cyV3tgmZz5AExxxdGJ12r+PPXn7v2AEhxb9icBxolS8=";
  };

  CXXDEFS = [ "-DHAVE_RAND" "-DHAVE_CSTRING" "-DHAVE_CSTDIO" ];

  configureFlags = [
    "--with-asl-cflags=-I${libamplsolver}/include"
    "--with-asl-lflags=-lamplsolver"
  ];

  nativeBuildInputs = [ pkg-config gfortran ];
  buildInputs = [ blas lapack ] ++ lib.optionals enableAMPL [ libamplsolver ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A software package for large-scale nonlinear optimization";
    homepage = "https://projects.coin-or.org/Ipopt";
    license = licenses.epl10;
    platforms = platforms.unix;
    maintainers = with maintainers; [ abbradar ];
  };
}
