{stdenv, fetchurl, lib, cmake}:

stdenv.mkDerivation {
  name = "eigen-2.0.5";
  src = fetchurl {
    url = http://bitbucket.org/eigen/eigen2/get/2.0.5.tar.bz2;
    sha256 = "0wzixg09fh0vmn8sh2vcdn3j1pxhvd2k2axmpr0vjss98aapvqgf";
  };
  buildInputs = [ cmake ];  
  meta = {
    description = "C++ template library for linear algebra: vectors, matrices, and related algorithms";
    license = "LGPL";
    homepage = http://eigen.tuxfamily.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
