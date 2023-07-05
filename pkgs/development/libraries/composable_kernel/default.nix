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
  version = "unstable-2023-01-16";

  outputs = [
    "out"
  ] ++ lib.optionals buildTests [
    "test"
  ] ++ lib.optionals buildExamples [
    "example"
  ];

  # ROCm 5.6 should release composable_kernel as stable with a tag in the future
  src = fetchFromGitHub {
    owner = "ROCmSoftwarePlatform";
    repo = "composable_kernel";
    rev = "80e05267417f948e4f7e63c0fe807106d9a0c0ef";
    hash = "sha256-+c0E2UtlG/abweLwCWWjNHDO5ZvSIVKwwwettT9mqR4=";
  };

  nativeBuildInputs = [
    cmake
    rocm-cmake
    hip
    clang-tools-extra
  ];

  buildInputs = [
    openmp
  ];

  cmakeFlags = [
    "-DCMAKE_C_COMPILER=hipcc"
    "-DCMAKE_CXX_COMPILER=hipcc"
  ] ++ lib.optionals (gpuTargets != [ ]) [
    "-DGPU_TARGETS=${lib.concatStringsSep ";" gpuTargets}"
    "-DAMDGPU_TARGETS=${lib.concatStringsSep ";" gpuTargets}"
  ] ++ lib.optionals buildTests [
    "-DGOOGLETEST_DIR=${gtest.src}" # Custom linker names
  ];

  # No flags to build selectively it seems...
  postPatch = lib.optionalString (!buildTests) ''
    substituteInPlace CMakeLists.txt \
      --replace "add_subdirectory(test)" ""
  '' + lib.optionalString (!buildExamples) ''
    substituteInPlace CMakeLists.txt \
      --replace "add_subdirectory(example)" ""
  '';

  postInstall = lib.optionalString buildTests ''
    mkdir -p $test/bin
    mv $out/bin/test_* $test/bin
  '' + lib.optionalString buildExamples ''
    mkdir -p $example/bin
    mv $out/bin/example_* $example/bin
  '';

  passthru.updateScript = unstableGitUpdater { };

  # Times out otherwise
  requiredSystemFeatures = [ "big-parallel" ];

  meta = with lib; {
    description = "Performance portable programming model for machine learning tensor operators";
    homepage = "https://github.com/ROCmSoftwarePlatform/composable_kernel";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
  };
})
