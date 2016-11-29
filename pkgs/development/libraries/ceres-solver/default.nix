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

let
  version = "1.10.0";
in
stdenv.mkDerivation {
  name = "ceres-solver-${version}";

  src = fetchurl {
    url = "http://ceres-solver.org/ceres-solver-${version}.tar.gz";
    sha256 = "20bb5db05c3e3e14a4062e2cf2b0742d2653359549ecded3e0653104ef3deb17";
  };

  buildInputs = [ cmake glog ]
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
    maintainers = with stdenv.lib.maintainers; [ giogadi ];
    inherit version;
    platforms = with stdenv.lib.platforms; unix;
  };
}
