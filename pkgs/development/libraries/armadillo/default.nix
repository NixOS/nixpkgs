{stdenv, fetchurl, cmake, pkgconfig, atlas, blas, openblas}:

stdenv.mkDerivation rec {
  version = "7.200.1b";
  name = "armadillo-${version}";
  
  src = fetchurl {
    url = "http://sourceforge.net/projects/arma/files/armadillo-${version}.tar.xz";
    sha256 = "00s8xrywc4aipipq1zpd6q9gzqmsiv8cwd25zvb1csrpninmidvc";
  };

  unpackCmd = [ "tar -xf ${src}" ];
  
  nativeBuildInputs = [ cmake atlas blas openblas ];
  
  meta = with stdenv.lib; {
    description = "C++ linear algebra library";
    homepage = "http://arma.sourceforge.net" ;
    license = licenses.mpl20;
    platforms = stdenv.lib.platforms.linux ;
    maintainers = [ stdenv.lib.maintainers.juliendehos ];
  };
}
