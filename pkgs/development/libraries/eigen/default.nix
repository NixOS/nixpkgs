{stdenv, fetchurl, cmake}:

let
  v = "3.1.2";
in
stdenv.mkDerivation {
  name = "eigen-${v}";
  
  src = fetchurl {
    url = "http://bitbucket.org/eigen/eigen/get/${v}.tar.bz2";
    name = "eigen-${v}.tar.bz2";
    sha256 = "1hywvbn4a8f96fjn3cvd6nxzh5jvh05s1r263d9vqlgn25dxrzay";
  };
  
  nativeBuildInputs = [ cmake ];
  
  meta = with stdenv.lib; {
    description = "C++ template library for linear algebra: vectors, matrices, and related algorithms";
    license = licenses.lgpl3Plus;
    homepage = http://eigen.tuxfamily.org ;
    maintainers = with stdenv.lib.maintainers; [ sander urkud raskin ];
  };
}
