{ stdenv, fetchurl, unzip, blas, liblapack, gfortran }:

stdenv.mkDerivation rec {
  version = "3.12.0";
  name = "ipopt-${version}";

  src = fetchurl {
    url = "http://www.coin-or.org/download/source/Ipopt/Ipopt-${version}.zip";
    sha256 = "18p1ad64mpliba1hf6jkyyrd0srxsqivwbcnbrr09jfpn4jn4bbr";
  };

  preConfigure = ''
     export CXXDEFS="-DHAVE_RAND -DHAVE_CSTRING -DHAVE_CSTDIO"
  '';

  nativeBuildInputs = [ unzip ];

  buildInputs = [ gfortran blas liblapack ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A software package for large-scale nonlinear optimization";
    homepage = https://projects.coin-or.org/Ipopt;
    license = licenses.epl10;
    platforms = platforms.unix;
    maintainers = with maintainers; [ abbradar ];
  };
}
