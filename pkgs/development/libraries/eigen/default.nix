{stdenv, fetchurl, cmake}:

let
  version = "3.2.3";
in
stdenv.mkDerivation {
  name = "eigen-${version}";
  
  src = fetchurl {
    url = "http://bitbucket.org/eigen/eigen/get/${version}.tar.gz";
    name = "eigen-${version}.tar.gz";
    sha256 = "14l5hlgxxymwyava5mx97ipyk3ma3alaj586aaz1xh1r700a7sxm";
  };
  
  nativeBuildInputs = [ cmake ];
  
  meta = with stdenv.lib; {
    description = "C++ template library for linear algebra: vectors, matrices, and related algorithms";
    license = licenses.lgpl3Plus;
    homepage = http://eigen.tuxfamily.org ;
    maintainers = with stdenv.lib.maintainers; [ sander urkud raskin ];
    inherit version;
  };
}
