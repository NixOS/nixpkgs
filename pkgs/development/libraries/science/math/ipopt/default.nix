{ stdenv, fetchurl, unzip, blas, lapack, gfortran }:

assert (!blas.isILP64) && (!lapack.isILP64);

stdenv.mkDerivation rec {
  pname = "ipopt";
  version = "3.12.13";

  src = fetchurl {
    url = "https://www.coin-or.org/download/source/Ipopt/Ipopt-${version}.zip";
    sha256 = "0kzf05aypx8q5mr3sciclk926ans0yi2d2chjdxxgpi3sza609dx";
  };

  CXXDEFS = [ "-DHAVE_RAND" "-DHAVE_CSTRING" "-DHAVE_CSTDIO" ];

  configureFlags = [
    "--with-blas-lib=-lblas"
    "--with-lapack-lib=-llapack"
  ];

  nativeBuildInputs = [ unzip ];

  buildInputs = [ gfortran blas lapack ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A software package for large-scale nonlinear optimization";
    homepage = "https://projects.coin-or.org/Ipopt";
    license = licenses.epl10;
    platforms = platforms.unix;
    maintainers = with maintainers; [ abbradar ];
  };
}
