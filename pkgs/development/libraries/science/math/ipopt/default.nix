{ stdenv, fetchurl, unzip, openblas, gfortran }:

stdenv.mkDerivation rec {
  name = "ipopt-${version}";
  version = "3.12.13";

  src = fetchurl {
    url = "https://www.coin-or.org/download/source/Ipopt/Ipopt-${version}.zip";
    sha256 = "0kzf05aypx8q5mr3sciclk926ans0yi2d2chjdxxgpi3sza609dx";
  };

  CXXDEFS = [ "-DHAVE_RAND" "-DHAVE_CSTRING" "-DHAVE_CSTDIO" ];

  configureFlags = [
    "--with-blas-lib=-lopenblas"
    "--with-lapack-lib=-lopenblas"
  ];

  nativeBuildInputs = [ unzip ];

  buildInputs = [ gfortran openblas ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A software package for large-scale nonlinear optimization";
    homepage = https://projects.coin-or.org/Ipopt;
    license = licenses.epl10;
    platforms = platforms.unix;
    maintainers = with maintainers; [ abbradar ];
  };
}
