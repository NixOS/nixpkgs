{ stdenv, fetchFromGitHub, fetchpatch, cmake, boost, libevent, double-conversion, glog
, google-gflags, gtest, libiberty, openssl }:

let
  disableTests = import ./disable-tests.nix { inherit (stdenv) lib; };
  optionals = stdenv.lib.optionals;
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

  patches = optionals stdenv.isDarwin [
    ./darwin-printf-test.patch
    ./macos-10.11.patch
  ] ++ optionals stdenv.isLinux [
    ./nixos-test-paths.patch
  ];
  postPatch = disableTests {
    "AsyncUDPSocketTest" = stdenv.isDarwin;
    "EventBaseTest" = true;
    "HHWheelTimerTest" = true;
    "baton_test" = stdenv.isDarwin;
    "codel_test" = stdenv.isDarwin;
    "deterministic_schedule_test" = stdenv.isDarwin;
    "exception_wrapper_test" = stdenv.isDarwin;
    "fibers_test" = stdenv.isDarwin;
    "folly/executors/test/ThreadPoolExecutorTest.cpp" = optionals stdenv.isLinux [ "CPUExpiration" ];
    "folly/experimental/test/LockFreeRingBufferTest.cpp" = optionals stdenv.isDarwin [ "writesNeverFail" ];
    "folly/experimental/test/TestUtilTest.cpp" = [ "ChunkCob" "GlogPatterns" ];
    "folly/fibers/test/FibersTest.cpp" = optionals stdenv.isLinux [ "batonTimedWaitPostEvb" "batonTimedWaitTimeoutEvb" ];
    "folly/futures/test/RetryingTest.cpp" = [ "policy_capped_jittered_exponential_backoff" ] ++ optionals stdenv.isDarwin [ "policy_sleep_defaults" ];
    "folly/futures/test/WaitTest.cpp" = optionals stdenv.isLinux [ "multipleWait" ];
    "folly/io/async/test/AsyncUDPSocketTest.cpp" = optionals stdenv.isLinux [ "ConnectedPingPong" ];
    "folly/logging/test/AsyncFileWriterTest.cpp" = [ "fork" ] ++ optionals stdenv.isDarwin [ "discard" ];
    "folly/test/FutexTest.cpp" = optionals stdenv.isDarwin [ "basic_deterministic" ];
    "folly/test/sorted_vector_test.cpp" = optionals stdenv.isDarwin [ "TestSetBulkInsertionSortMerge" "TestSetBulkInsertionSortMergeDups" "TestSetBulkInsertionSortNoMerge" ];
    "lifo_sem_test" = stdenv.isDarwin;
    "ssl_session_test" = stdenv.isDarwin;
  };

  cmakeFlags = [
    "-DBUILD_TESTS:BOOL=ON"
    "-DUSE_CMAKE_GOOGLE_TEST_INTEGRATION:BOOL=ON"
  ];
  CXXFLAGS = optionals stdenv.cc.isGNU [
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
    platforms = [ "x86_64-darwin" "x86_64-linux" ];
    maintainers = with maintainers; [ abbradar ];
  };
}
