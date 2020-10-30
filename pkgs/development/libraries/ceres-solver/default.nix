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
  version = "2.0.0";

  src = fetchurl {
    url = "http://ceres-solver.org/ceres-solver-${version}.tar.gz";
    sha256 = "00vng9vnmdb1qga01m0why90m0041w7bn6kxa2h4m26aflfqla8h";
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
