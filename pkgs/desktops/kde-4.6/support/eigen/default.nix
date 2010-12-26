{stdenv, fetchurl, cmake}:

let
  v = "2.0.15";
in
stdenv.mkDerivation {
  name = "eigen-${v}";
  src = fetchurl {
    url = "http://bitbucket.org/eigen/eigen/get/${v}.tar.bz2";
    name = "eigen-${v}.tar.bz2";
    sha256 = "1a00hqyig4rc7nkz97xv23q7k0vdkzvgd0jkayk61fn9aqcrky79";
  };
  buildInputs = [ cmake ];
  meta = {
    description = "C++ template library for linear algebra: vectors, matrices, and related algorithms";
    license = "LGPL";
    homepage = http://eigen.tuxfamily.org ;
    maintainers = with stdenv.lib.maintainers; [ sander urkud ];
  };
}
