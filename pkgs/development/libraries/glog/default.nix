{ stdenv, lib, fetchFromGitHub, cmake, gflags, gtest, perl }:

stdenv.mkDerivation rec {
  pname = "glog";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "glog";
    rev = "v${version}";
    sha256 = "sha256-xqRp9vaauBkKz2CXbh/Z4TWqhaUtqfbsSlbYZR/kW9s=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ gtest ];

  propagatedBuildInputs = [ gflags ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    # glog's custom FindUnwind.cmake module detects LLVM's unwind in case
    # stdenv.cc is clang. But the module doesn't get installed, causing
    # consumers of the CMake config file to fail at the configuration step.
    # Explicitly disabling unwind support sidesteps the issue.
    "-DWITH_UNWIND=OFF"
  ];

  doCheck = true;

  # There are some non-thread safe tests that can fail
  enableParallelChecking = false;
  nativeCheckInputs = [ perl ];

  env.GTEST_FILTER =
    let
      filteredTests = lib.optionals stdenv.hostPlatform.isMusl [
        "Symbolize.SymbolizeStackConsumption"
        "Symbolize.SymbolizeWithDemanglingStackConsumption"
      ] ++ lib.optionals stdenv.hostPlatform.isStatic [
        "LogBacktraceAt.DoesBacktraceAtRightLineWhenEnabled"
      ] ++ lib.optionals stdenv.cc.isClang [
        # Clang optimizes an expected allocation away.
        # See https://github.com/google/glog/issues/937
        "DeathNoAllocNewHook.logging"
      ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
        "LogBacktraceAt.DoesBacktraceAtRightLineWhenEnabled"
      ];
    in
    "-${builtins.concatStringsSep ":" filteredTests}";

  checkPhase =
    let
      excludedTests = lib.optionals stdenv.hostPlatform.isDarwin [
        "mock-log"
      ] ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
        "logging"   # works around segfaults on aarch64-darwin for now
      ];
      excludedTestsRegex = lib.optionalString (excludedTests != [ ]) "(${lib.concatStringsSep "|" excludedTests})";
    in
    ''
      runHook preCheck
      ctest -E "${excludedTestsRegex}" --output-on-failure
      runHook postCheck
    '';

  meta = with lib; {
    homepage = "https://github.com/google/glog";
    license = licenses.bsd3;
    description = "Library for application-level logging";
    platforms = platforms.unix;
    maintainers = with maintainers; [ nh2 r-burns ];
  };
}
