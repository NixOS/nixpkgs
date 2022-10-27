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
, runTests ? false
, enableStatic ? stdenv.hostPlatform.isStatic
, withBlas ? true
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

  outputs = [ "out" "dev" ];

  patches = [
    # Enable GNUInstallDirs, see: https://github.com/ceres-solver/ceres-solver/pull/706
    (fetchpatch {
      url = "https://github.com/ceres-solver/ceres-solver/commit/4998c549396d36a491f1c0638fe57824a40bcb0d.patch";
      sha256 = "sha256-mF6Zh2fDVzg2kD4nI2dd9rp4NpvPErmwfdYo5JaBmCA=";
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = lib.optional runTests gflags;
  propagatedBuildInputs = [ eigen glog ]
  ++ lib.optionals withBlas [ blas suitesparse ];

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
