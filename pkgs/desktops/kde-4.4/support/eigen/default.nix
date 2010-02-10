{stdenv, fetchurl, lib, cmake}:

stdenv.mkDerivation {
  name = "eigen-2.0.11";
  src = fetchurl {
    url = http://bitbucket.org/eigen/eigen/get/2.0.11.tar.bz2;
    sha256 = "0zlv6isqhz0krzh77h8xiy1sglig7j17135qnna0gar0fa6kcj7l";
  };
  buildInputs = [ cmake ];  
  meta = {
    description = "C++ template library for linear algebra: vectors, matrices, and related algorithms";
    license = "LGPL";
    homepage = http://eigen.tuxfamily.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
