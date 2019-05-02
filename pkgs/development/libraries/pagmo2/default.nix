{ lib
, fetchFromGitHub
, stdenv
, cmake
, eigen
, nlopt
, ipopt
, boost
, writeText
}:

stdenv.mkDerivation rec {
  name = "pagmo2-${version}";
  version = "2.9";

  src = fetchFromGitHub {
     owner = "esa";
     repo = "pagmo2";
     rev = "v${version}";
     sha256 = "0al2i59m5qr83wz5n5408zvys0b3mc40rszf0l5b9a0gp1axj400";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ eigen nlopt ipopt boost ];

  cmakeFlags = [
    "-DPAGMO_BUILD_TESTS=no"
    "-DPAGMO_WITH_EIGEN3=yes"
    "-DPAGMO_WITH_NLOPT=yes"
    "-DNLOPT_LIBRARY=${nlopt}/lib/libnlopt.so"
    "-DPAGMO_WITH_IPOPT=yes"
    "-DCMAKE_CXX_FLAGS='-fuse-ld=gold'"
  ];

  # tests pass but take 30+ minutes
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://esa.github.io/pagmo2/;
    description = "Scientific library for massively parallel optimization";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.costrouc ];
  };
}
