{
  fetchFromGitHub,
  lib,
  stdenv,
  # nativeBuildInputs
  cmake,
  ninja,
  pkg-config,
  # buildInputs
  libpfm,
  # checkInputs
  filecheck,
  gtest,
  # Configuration options
  buildSharedLibs ? true,
  enableLTO ? true,
  enableLibPFM ? true,
}: let
  inherit
    (lib)
    lists
    strings
    ;
  setBool = bool:
    if bool
    then "ON"
    else "OFF";
  setBuildSharedLibrary = bool:
    if bool
    then "shared"
    else "static";
in
  stdenv.mkDerivation (finalAttrs: {
    strictDeps = true;
    pname = "benchmark";
    version = "1.8.0";
    src = fetchFromGitHub {
      owner = "google";
      repo = finalAttrs.pname;
      rev = "v${finalAttrs.version}";
      hash = "sha256-pUW9YVaujs/y00/SiPqDgK4wvVsaM7QUp/65k0t7Yr0=";
    };
    postPatch = strings.optionalString enableLibPFM ''
      substituteInPlace test/perf_counters_gtest.cc \
        --replace \
          'TEST(PerfCountersTest, NegativeTest) {' \
          'TEST(PerfCountersTest, NegativeTest) { GTEST_SKIP() << "Skipping single test";'
    '';
    nativeBuildInputs = [
      cmake
      ninja
      pkg-config
    ];
    buildInputs = lists.optionals enableLibPFM [libpfm];
    checkInputs = [
      filecheck
      gtest
    ];
    cmakeFlags =
      [
        "-DBENCHMARK_DOWNLOAD_DEPENDENCIES=OFF"
        # TODO(@connorbaker): Assembly tests require filecheck, which isn't correctly detected, and
        # fails to compile. Also warns because we're using a version of GCC newer than 5.x.
        "-DBENCHMARK_ENABLE_ASSEMBLY_TESTS=OFF"
        "-DBENCHMARK_ENABLE_GTEST_TESTS=${setBool finalAttrs.doCheck}"
        "-DBENCHMARK_ENABLE_LIBPFM=${setBool enableLibPFM}"
        "-DBENCHMARK_ENABLE_LTO=${setBool enableLTO}"
        "-DBENCHMARK_ENABLE_TESTING=${setBool finalAttrs.doCheck}"
        "-DBENCHMARK_INSTALL_DOCS=ON"
        "-DBENCHMARK_USE_BUNDLED_GTEST=OFF"
        # TODO(@connorbaker): Test with clang
        # "-DBENCHMARK_USE_LIBCXX=OFF"
        # NOTE: When building static libraries, you may get linker errors due to private symbols!
        "-DBUILD_SHARED_LIBS=${setBuildSharedLibrary buildSharedLibs}"
      ]
      ++ lists.optionals finalAttrs.doCheck [
        "-DLLVM_FILECHECK_EXE=${lib.getExe filecheck}"
      ];
    doCheck = true;
    enableParallelChecking = false;
    meta = with lib; {
      description = "A microbenchmark support library";
      homepage = "https://github.com/google/benchmark";
      license = licenses.asl20;
      maintainers = with maintainers; [connorbaker];
      platforms = platforms.all;
    };
  })
