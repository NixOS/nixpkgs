{ lib
, stdenv
, fetchFromGitHub
, unstableGitUpdater
, cmake
, rocm-cmake
, hip
, openmp
, clang-tools-extra
, gtest
, buildTests ? false
, buildExamples ? false
, gpuTargets ? [ ] # gpuTargets = [ "gfx803" "gfx900" "gfx1030" ... ]
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "composable_kernel";
  version = "unstable-2022-12-15";

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
    rev = "0345963eef4f92e9c5eab608bb8557b5463a1dcb";
    hash = "sha256-IJbUZ3/UIPbYO9H+BUPP6T2HyUnC+FVbVPXQE5bEjRg=";
  };

  nativeBuildInputs = [
    cmake
    rocm-cmake
    hip
    clang-tools-extra
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
    # Well, at least we're getting something that makes sense now
    # undefined symbol: testing::Message::Message()
    # Try removing this next update
    broken = buildTests;
  };
})
