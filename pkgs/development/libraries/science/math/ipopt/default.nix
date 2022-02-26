{ lib, stdenv, fetchFromGitHub, pkg-config, blas, lapack, gfortran }:

assert (!blas.isILP64) && (!lapack.isILP64);

stdenv.mkDerivation rec {
  pname = "ipopt";
  version = "3.14.5";

  src = fetchFromGitHub {
    owner = "coin-or";
    repo = "Ipopt";
    rev = "releases/${version}";
    sha256 = "sha256-eqOacZGuuGAjWMs2H6RntQ+WJmGTi+EqydHUQXEpY54=";
  };

  CXXDEFS = [ "-DHAVE_RAND" "-DHAVE_CSTRING" "-DHAVE_CSTDIO" ];

  nativeBuildInputs = [ pkg-config gfortran ];
  buildInputs = [ blas lapack ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A software package for large-scale nonlinear optimization";
    homepage = "https://projects.coin-or.org/Ipopt";
    license = licenses.epl10;
    platforms = platforms.unix;
    maintainers = with maintainers; [ abbradar ];
  };
}
