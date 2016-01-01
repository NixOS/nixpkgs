{stdenv, fetchurl, cmake}:

let
  version = "3.3-alpha1";
in
stdenv.mkDerivation {
  name = "eigen-${version}";
  
  src = fetchurl {
    url = "http://bitbucket.org/eigen/eigen/get/${version}.tar.gz";
    name = "eigen-${version}.tar.gz";
    sha256 = "00vmxz3da76ml3j7s8w8447sdpszx71i3xhnmwivxhpc4smpvz2q";
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
