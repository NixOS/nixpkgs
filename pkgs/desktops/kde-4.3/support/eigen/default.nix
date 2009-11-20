{stdenv, fetchurl, lib, cmake}:

stdenv.mkDerivation {
  name = "eigen-2.0.9";
  src = fetchurl {
    url = http://bitbucket.org/eigen/eigen/get/2.0.9.tar.bz2;
    sha256 = "0hdsn44lv6nxypbrh3y19qk1p1579wk2v32fkav799c99wh0lss5";
  };
  buildInputs = [ cmake ];  
  meta = {
    description = "C++ template library for linear algebra: vectors, matrices, and related algorithms";
    license = "LGPL";
    homepage = http://eigen.tuxfamily.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
