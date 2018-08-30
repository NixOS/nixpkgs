{ stdenv
, eigen
, fetchurl
, cmake
, google-gflags ? null
, glog
, runTests ? false
}:

# google-gflags is required to run tests
assert runTests -> google-gflags != null;

stdenv.mkDerivation rec {
  name = "ceres-solver-${version}";
  version = "1.14.0";

  src = fetchurl {
    url = "http://ceres-solver.org/ceres-solver-${version}.tar.gz";
    sha256 = "13lfxy8x58w8vprr0nkbzziaijlh0vvqshgahvcgw0mrqdgh0i27";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ eigen glog ]
    ++ stdenv.lib.optional (google-gflags != null) google-gflags;

  doCheck = runTests;

  checkTarget = "test";

  meta = with stdenv.lib; {
    description = "C++ library for modeling and solving large, complicated optimization problems";
    license = licenses.bsd3;
    homepage = http://ceres-solver.org;
    maintainers = with maintainers; [ giogadi ];
    platforms = platforms.unix;
  };
}
