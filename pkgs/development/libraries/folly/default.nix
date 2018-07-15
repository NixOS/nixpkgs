{ stdenv, fetchFromGitHub, fetchpatch, cmake, boost, libevent, double-conversion, glog
, google-gflags, gtest, libiberty, openssl }:

let
  disableTests = import ./disable-tests.nix { inherit (stdenv) lib; };
in stdenv.mkDerivation rec {
  name = "folly-${version}";
  version = "2019.04.22.00";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "folly";
    rev = "v${version}";
    sha256 = "08aniprv2a96d3k36k668maq9nysxh0cm58i0hvy71cqcmc97h7p";
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

  patches = [ ./nixos-test-paths.patch ];
  postPatch = disableTests {
    "EventBaseTest" = true;
    "HHWheelTimerTest" = true;
    "folly/executors/test/ThreadPoolExecutorTest.cpp" = [ "CPUExpiration" ];
    "folly/experimental/test/TestUtilTest.cpp" = [ "ChunkCob" "GlogPatterns" ];
    "folly/fibers/test/FibersTest.cpp" = [ "batonTimedWaitPostEvb" "batonTimedWaitTimeoutEvb" ];
    "folly/futures/test/RetryingTest.cpp" = [ "policy_capped_jittered_exponential_backoff" ];
    "folly/futures/test/WaitTest.cpp" = [ "multipleWait" ];
    "folly/io/async/test/AsyncUDPSocketTest.cpp" = [ "ConnectedPingPong" ];
    "folly/logging/test/AsyncFileWriterTest.cpp" = [ "fork" ];
  };

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
