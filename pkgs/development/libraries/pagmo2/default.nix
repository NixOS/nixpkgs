{ fetchFromGitHub
, lib, stdenv
, cmake
, eigen
, nlopt
, ipopt
, boost
, tbb
}:

stdenv.mkDerivation rec {
  pname = "pagmo2";
  version = "2.18.0";

  src = fetchFromGitHub {
     owner = "esa";
     repo = "pagmo2";
     rev = "v${version}";
     sha256 = "0rd8scs4hj6qd8ylmn5hafncml2vr4fvcgm3agz3jrvmnc7hadrj";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ eigen nlopt ipopt boost tbb ];

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

  meta = with lib; {
    homepage = "https://esa.github.io/pagmo2/";
    description = "Scientific library for massively parallel optimization";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.costrouc ];
  };
}
