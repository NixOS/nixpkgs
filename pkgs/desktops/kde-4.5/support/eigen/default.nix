{stdenv, fetchurl, lib, cmake}:

let
  v = "2.0.14";
in
stdenv.mkDerivation {
  name = "eigen-${v}";
  src = fetchurl {
    url = "http://bitbucket.org/eigen/eigen/get/${v}.tar.bz2";
    name = "eigen-${v}.tar.bz2";
    sha256 = "01xkdqs6hqkwcq5yzpdz79da0i512s818pbg8fl9w3m2vvndzs6p";
  };
  buildInputs = [ cmake ];
  meta = {
    description = "C++ template library for linear algebra: vectors, matrices, and related algorithms";
    license = "LGPL";
    homepage = http://eigen.tuxfamily.org ;
    maintainers = [ lib.maintainers.sander ];
  };
}
