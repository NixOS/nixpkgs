{stdenv, fetchurl, cmake}:

let
  v = "3.2.1";
in
stdenv.mkDerivation {
  name = "eigen-${v}";
  
  src = fetchurl {
    url = "http://bitbucket.org/eigen/eigen/get/${v}.tar.bz2";
    name = "eigen-${v}.tar.bz2";
    sha256 = "12ljdirih9n3cf8hy00in285c2ccah7mgalmmr8gc3ldwznz5rk6";
  };
  
  nativeBuildInputs = [ cmake ];
  
  meta = with stdenv.lib; {
    description = "C++ template library for linear algebra: vectors, matrices, and related algorithms";
    license = licenses.lgpl3Plus;
    homepage = http://eigen.tuxfamily.org ;
    maintainers = with stdenv.lib.maintainers; [ sander urkud raskin ];
  };
}
