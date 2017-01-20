{stdenv, fetchurl, cmake}:

let
  version = "3.3.1";
in
stdenv.mkDerivation {
  name = "eigen-${version}";
  
  src = fetchurl {
    url = "http://bitbucket.org/eigen/eigen/get/${version}.tar.gz";
    name = "eigen-${version}.tar.gz";
    sha256 = "141axgv5kykq7125scisjvnfcdx7qcj8n8zlk7g09r7fhqgjr79w";
  };
  
  nativeBuildInputs = [ cmake ];
  
  meta = with stdenv.lib; {
    description = "C++ template library for linear algebra: vectors, matrices, and related algorithms";
    license = licenses.lgpl3Plus;
    homepage = http://eigen.tuxfamily.org ;
    platforms = platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ sander urkud raskin ];
    inherit version;
  };
}
