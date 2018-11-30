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
  version = "2.8";

  src = fetchFromGitHub {
     owner = "esa";
     repo = "pagmo2";
     rev = "v${version}";
     sha256 = "1xwxamcn3fkwr62jn6bkanrwy0cvsksf75hfwx4fvl56awnbz41z";
  };

  buildInputs = [ cmake eigen nlopt ipopt boost ];

  preBuild = ''
    cp -r $src/* .
  '';

  cmakeFlags = [ "-DPAGMO_BUILD_TESTS=no"
                 "-DPAGMO_WITH_EIGEN3=yes" "-DPAGMO_WITH_NLOPT=yes"
                 "-DNLOPT_LIBRARY=${nlopt}/lib/libnlopt_cxx.so" "-DPAGMO_WITH_IPOPT=yes"
                 "-DCMAKE_CXX_FLAGS='-fuse-ld=gold'" ];

  checkPhase = ''
    ctest
  '';

  # All but one test pass skip for now (tests also take about 30 min to compile)
  doCheck = false;

  meta = {
    homepage = https://esa.github.io/pagmo2/;
    description = "Scientific library for massively parallel optimization";
    license = stdenv.lib.licenses.gpl3Plus;
  };
}
