{ lib
, stdenv
, fetchFromGitHub
, unstableGitUpdater
, cmake
, rocm-cmake
, hip
, openmp
, gtest
, buildTests ? false
, buildExamples ? false
, gpuTargets ? [ ] # gpuTargets = [ "gfx803" "gfx900" "gfx1030" ... ]
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "composable_kernel";
  version = "unstable-2022-12-08";

  outputs = [
    "out"
  ] ++ lib.optionals buildTests [
    "test"
  ] ++ lib.optionals buildExamples [
    "example"
  ];

  # There is now a release, but it's cpu-only it seems to be for a very specific purpose
  # Thus, we're sticking with the develop branch for now...
  src = fetchFromGitHub {
    owner = "ROCmSoftwarePlatform";
    repo = "composable_kernel";
    rev = "d58b7f5155b44c8b608f3edc6a6eab314493ec1a";
    hash = "sha256-4nzyaWhPnY/0TygcoJAqVzdgfXOkf+o/BE2V9N+Bm7Q=";
  };

  nativeBuildInputs = [
    cmake
    rocm-cmake
    hip
  ];

  buildInputs = [
    openmp
  ] ++ lib.optionals buildTests [
    gtest
  ];

  cmakeFlags = [
    "-DCMAKE_C_COMPILER=hipcc"
    "-DCMAKE_CXX_COMPILER=hipcc"
  ] ++ lib.optionals (gpuTargets != [ ]) [
    "-DGPU_TARGETS=${lib.concatStringsSep ";" gpuTargets}"
  ];

  # No flags to build selectively it seems...
  postPatch = ''
    substituteInPlace test/CMakeLists.txt \
      --replace "include(googletest)" ""

    substituteInPlace CMakeLists.txt \
      --replace "enable_testing()" ""
  '' + lib.optionalString (!buildTests) ''
    substituteInPlace CMakeLists.txt \
      --replace "add_subdirectory(test)" ""
  '' + lib.optionalString (!buildExamples) ''
    substituteInPlace CMakeLists.txt \
      --replace "add_subdirectory(example)" ""
  '';

  postInstall = ''
    mkdir -p $out/bin
    mv bin/ckProfiler $out/bin
  '' + lib.optionalString buildTests ''
    mkdir -p $test/bin
    mv bin/test_* $test/bin
  '' + lib.optionalString buildExamples ''
    mkdir -p $example/bin
    mv bin/example_* $example/bin
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Performance portable programming model for machine learning tensor operators";
    homepage = "https://github.com/ROCmSoftwarePlatform/composable_kernel";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    # Several tests seem to either not compile or have a race condition
    # Undefined reference to symbol '_ZTIN7testing4TestE'
    # Try removing this next update
    broken = buildTests;
  };
})
