{stdenv, fetchurl, cmake}:

let
  v = "2.0.16";
in
stdenv.mkDerivation {
  name = "eigen-${v}";
  
  src = fetchurl {
    url = "http://bitbucket.org/eigen/eigen/get/${v}.tar.bz2";
    name = "eigen-${v}.tar.bz2";
    sha256 = "04lzlhl7r1yqkpq9xabm1v5vgz0z9xqf1k7indgwdw8nfyma3qar";
  };
  
  buildNativeInputs = [ cmake ];
  
  meta = with stdenv.lib; {
    description = "C++ template library for linear algebra: vectors, matrices, and related algorithms";
    license = licenses.lgpl3Plus;
    homepage = http://eigen.tuxfamily.org ;
    maintainers = with stdenv.lib.maintainers; [ sander urkud raskin ];
  };
}
