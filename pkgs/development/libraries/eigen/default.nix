{stdenv, fetchurl, cmake}:

let
  v = "3.2.0";
in
stdenv.mkDerivation {
  name = "eigen-${v}";
  
  src = fetchurl {
    url = "http://bitbucket.org/eigen/eigen/get/${v}.tar.bz2";
    name = "eigen-${v}.tar.bz2";
    sha256 = "1dpshkcqjz3ckad56mkk1agbnlq0rk2d0wv14zwjg4lk1nb7h7q1";
  };
  
  nativeBuildInputs = [ cmake ];
  
  meta = with stdenv.lib; {
    description = "C++ template library for linear algebra: vectors, matrices, and related algorithms";
    license = licenses.lgpl3Plus;
    homepage = http://eigen.tuxfamily.org ;
    maintainers = with stdenv.lib.maintainers; [ sander urkud raskin ];
  };
}
