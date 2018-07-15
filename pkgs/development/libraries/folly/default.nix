{ stdenv, fetchFromGitHub, fetchpatch, cmake, boost, libevent, double-conversion, glog
, google-gflags, gtest, libiberty, openssl }:

stdenv.mkDerivation rec {
  name = "folly-${version}";
  version = "2019.03.18.00";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "folly";
    rev = "v${version}";
    sha256 = "0g7c2lq4prcw9dd5r4q62l8kqm8frczrfq8m4mgs22np60yvmb6d";
  };

  nativeBuildInputs = [ cmake ];

  # See CMake/folly-deps.cmake in the Folly source tree.
  buildInputs = [
    boost
    double-conversion
    glog
    google-gflags
    libevent
    libiberty
    openssl
  ];

  patches = [ ./disable-tests-x86_64-linux.patch ];

  cmakeFlags = [
    "-DBUILD_TESTS:BOOL=ON"
    "-DUSE_CMAKE_GOOGLE_TEST_INTEGRATION:BOOL=ON"
  ];
  CXXFLAGS = [
    "-Wno-error=maybe-uninitialized"
    "-Wno-error=stringop-overflow"
  ];

  enableParallelBuilding = true;

  checkInputs = [ gtest ];
  checkTarget = "test";
  doCheck = true;

  meta = with stdenv.lib; {
    description = "An open-source C++ library developed and used at Facebook";
    homepage = https://github.com/facebook/folly;
    license = licenses.asl20;
    # 32bit is not supported: https://github.com/facebook/folly/issues/103
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ abbradar ];
  };
}
