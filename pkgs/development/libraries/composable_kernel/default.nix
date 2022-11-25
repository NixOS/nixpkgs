{ lib
, stdenv
, fetchFromGitHub
, cmake
, rocm-cmake
, hip
, openmp
, gtest ? null
, buildTests ? false
, buildExamples ? false
, gpuTargets ? null # gpuTargets = [ "gfx803" "gfx900" "gfx1030" ... ]
}:

assert buildTests -> gtest != null;

# Several tests seem to either not compile or have a race condition
# Undefined reference to symbol '_ZTIN7testing4TestE'
# Try removing this next update
assert buildTests == false;

stdenv.mkDerivation (finalAttrs: {
  pname = "composable_kernel";
  version = "unstable-2022-11-19";

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
    rev = "43a889b72e3faabf04c16ff410d387ce28486c3e";
    hash = "sha256-DDRrWKec/RcOhW3CrN0gl9NZsp0Bjnja7HAiTcEh7qg=";
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
  ] ++ lib.optionals (gpuTargets != null) [
    "-DGPU_TARGETS=${lib.strings.concatStringsSep ";" gpuTargets}"
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

  meta = with lib; {
    description = "Performance portable programming model for machine learning tensor operators";
    homepage = "https://github.com/ROCmSoftwarePlatform/composable_kernel";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
  };
})
