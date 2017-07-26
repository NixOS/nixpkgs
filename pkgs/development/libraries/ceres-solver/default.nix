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
  version = "1.12.0";

  src = fetchurl {
    url = "http://ceres-solver.org/ceres-solver-${version}.tar.gz";
    sha256 = "15f8mwhcy9f5qggcc9dqwl5y687ykvmlidr686aqdq0ia7azwnvl";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ glog ]
    ++ stdenv.lib.optional (google-gflags != null) google-gflags;

  inherit eigen;

  doCheck = runTests;

  checkTarget = "test";

  cmakeFlags = "
    -DEIGEN_INCLUDE_DIR=${eigen}/include/eigen3
  ";

  meta = with stdenv.lib; {
    description = "C++ library for modeling and solving large, complicated optimization problems";
    license = licenses.bsd3;
    homepage = "http://ceres-solver.org";
    maintainers = with maintainers; [ giogadi ];
    platforms = platforms.unix;
  };
}
