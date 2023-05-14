{ lib
, stdenv
, fetchpatch
, fetchurl
, blas
, cmake
, eigen
, gflags
, glog
, suitesparse
, metis
, runTests ? false
, enableStatic ? stdenv.hostPlatform.isStatic
, withBlas ? true
}:

# gflags is required to run tests
assert runTests -> gflags != null;

stdenv.mkDerivation rec {
  pname = "ceres-solver";
  version = "2.1.0";

  src = fetchurl {
    url = "http://ceres-solver.org/ceres-solver-${version}.tar.gz";
    sha256 = "sha256-99dO7N4K7XW/xR7EjJHQH+Fqa/FrzhmHpwcyhnAeL8Y=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake ];
  buildInputs = lib.optional runTests gflags;
  propagatedBuildInputs = [ eigen glog ]
  ++ lib.optionals withBlas [ blas suitesparse metis ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=${if enableStatic then "OFF" else "ON"}"
  ];

  # The Basel BUILD file conflicts with the cmake build directory on
  # case-insensitive filesystems, eg. darwin.
  preConfigure = ''
    rm BUILD
  '';

  doCheck = runTests;

  checkTarget = "test";

  meta = with lib; {
    description = "C++ library for modeling and solving large, complicated optimization problems";
    license = licenses.bsd3;
    homepage = "http://ceres-solver.org";
    maintainers = with maintainers; [ giogadi ];
    platforms = platforms.unix;
  };
}
