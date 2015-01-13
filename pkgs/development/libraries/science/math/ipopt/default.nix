{ stdenv, fetchurl, unzip, blas, liblapack, gfortran }:

stdenv.mkDerivation rec {
  version = "3.11.9";
  name = "ipopt-${version}";

  src = fetchurl {
    url = "http://www.coin-or.org/download/source/Ipopt/Ipopt-${version}.zip";
    sha256 = "0sji4spl5dhw1s3f9y0ym09gi7d1c8wldn6wbiap4q8dq7cvklq5";
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
