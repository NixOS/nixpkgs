{ stdenv, fetchurl, unzip, openblas, gfortran }:

stdenv.mkDerivation rec {
  name = "ipopt-${version}";
  version = "3.12.9";

  src = fetchurl {
    url = "http://www.coin-or.org/download/source/Ipopt/Ipopt-${version}.zip";
    sha256 = "1fqdjgxh6l1xjvw1ffma7lg92xqg0l8sj02y0zqvbfnx8i47qs9a";
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
