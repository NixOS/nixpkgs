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

stdenv.mkDerivation rec {
  pname = "composable_kernel";
  version = "unstable-2022-11-02";

  outputs = [
    "out"
  ] ++ lib.optionals buildTests [
    "test"
  ] ++ lib.optionals buildExamples [
    "example"
  ];

  src = fetchFromGitHub {
    owner = "ROCmSoftwarePlatform";
    repo = "composable_kernel";
    rev = "79aa3fb1793c265c59d392e916baa851a55521c8";
    hash = "sha256-vIfMdvRYCTqrjMGSb7gQfodzLw2wf3tGoCAa5jtfbvw=";
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
    maintainers = with maintainers; [ Madouura ];
  };
}
