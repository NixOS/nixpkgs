{ stdenv
, eigen
, fetchurl
, cmake
, gflags
, glog
, runTests ? false
}:

# gflags is required to run tests
assert runTests -> gflags != null;

stdenv.mkDerivation rec {
  pname = "ceres-solver";
  version = "1.14.0";

  src = fetchurl {
    url = "http://ceres-solver.org/ceres-solver-${version}.tar.gz";
    sha256 = "13lfxy8x58w8vprr0nkbzziaijlh0vvqshgahvcgw0mrqdgh0i27";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ eigen glog ]
    ++ stdenv.lib.optional runTests gflags;

  # The Basel BUILD file conflicts with the cmake build directory on
  # case-insensitive filesystems, eg. darwin.
  preConfigure = ''
    rm BUILD
  '';

  doCheck = runTests;

  checkTarget = "test";

  meta = with stdenv.lib; {
    description = "C++ library for modeling and solving large, complicated optimization problems";
    license = licenses.bsd3;
    homepage = "http://ceres-solver.org";
    maintainers = with maintainers; [ giogadi ];
    platforms = platforms.unix;
  };
}
