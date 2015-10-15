{ stdenv, fetchurl, unzip, openblas, gfortran }:

stdenv.mkDerivation rec {
  version = "3.12.4";
  name = "ipopt-${version}";

  src = fetchurl {
    url = "http://www.coin-or.org/download/source/Ipopt/Ipopt-${version}.zip";
    sha256 = "0hxmpi3zx5zgv2ijscdvc40xf88hx5if0d9sgch155z70g15wx0l";
  };

  preConfigure = ''
     export CXXDEFS="-DHAVE_RAND -DHAVE_CSTRING -DHAVE_CSTDIO"
  '';

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
