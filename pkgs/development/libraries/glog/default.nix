{
  cmake,
  fetchFromGitHub,
  gflags,
  gtest,
  lib,
  perl,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "glog";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "glog";
    rev = "v${version}";
    hash = "sha256-+nwWP6VBmhgU7GCPSEGUzvUSCc48wXME181WpJ5ABP4=";
  };

  outputs = [
    "dev"
    "out"
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    # glog's custom FindUnwind.cmake module detects LLVM's unwind in case
    # stdenv.cc is clang. But the module doesn't get installed, causing
    # consumers of the CMake config file to fail at the configuration step.
    # Explicitly disabling unwind support sidesteps the issue.
    "-DWITH_UNWIND=OFF"
  ];

  env.GTEST_FILTER =
    let
      filteredTests =
        lib.optionals stdenv.hostPlatform.isMusl [
          "Symbolize.SymbolizeStackConsumption"
          "Symbolize.SymbolizeWithDemanglingStackConsumption"
        ]
        ++ lib.optionals stdenv.hostPlatform.isStatic [
          "LogBacktraceAt.DoesBacktraceAtRightLineWhenEnabled"
        ]
        ++ lib.optionals stdenv.cc.isClang [
          # Clang optimizes an expected allocation away.
          # See https://github.com/google/glog/issues/937
          "DeathNoAllocNewHook.logging"
        ]
        ++ lib.optionals stdenv.hostPlatform.isDarwin [
          "LogBacktraceAt.DoesBacktraceAtRightLineWhenEnabled"
        ];
    in
    "-${builtins.concatStringsSep ":" filteredTests}";

  # Non-thread safe tests can fail
  enableParallelChecking = false;

  strictDeps = true;

  nativeBuildInputs = [ cmake ];

  buildInputs = [ gtest ];

  propagatedBuildInputs = [ gflags ];

  doCheck = true;

  nativeCheckInputs = [ perl ];

  checkPhase =
    let
      excludedTests =
        lib.optionals stdenv.hostPlatform.isDarwin [
          "mock-log"
        ]
        ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
          "logging" # works around segfaults on aarch64-darwin for now
        ];
      excludedTestsRegex = lib.optionalString (
        excludedTests != [ ]
      ) "(${lib.concatStringsSep "|" excludedTests})";
    in
    ''
      runHook preCheck
      ctest -E "${excludedTestsRegex}" --output-on-failure
      runHook postCheck
    '';

  meta = {
    description = "Library for application-level logging";
    changelog = "https://github.com/google/glog/releases/tag/v${version}";
    homepage = "https://github.com/google/glog";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      nh2
      r-burns
    ];
  };
}
