{ lib
, stdenv
, cmake
, ninja
, gtest
, fetchFromGitHub
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "libhwy";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "google";
    repo = "highway";
    rev = version;
    hash = "sha256-Z+mAR9nSAbCskUvo6oK79Yd85bu0HtI2aR5THS1EozM=";
  };

  patches = lib.optional stdenv.hostPlatform.isRiscV
    # Adds CMake option HWY_CMAKE_RVV
    # https://github.com/google/highway/pull/1743
    (fetchpatch {
      name = "libhwy-add-rvv-optout.patch";
      url = "https://github.com/google/highway/commit/5d58d233fbcec0c6a39df8186a877329147324b3.patch";
      hash = "sha256-ileSNYddOt1F5rooRB0fXT20WkVlnG+gP5w7qJdBuww=";
    });

  nativeBuildInputs = [ cmake ninja ];

  # Required for case-insensitive filesystems ("BUILD" exists)
  dontUseCmakeBuildDir = true;

  cmakeFlags = let
    libExt = stdenv.hostPlatform.extensions.library;
  in [
    "-GNinja"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ] ++ lib.optionals doCheck [
    "-DHWY_SYSTEM_GTEST:BOOL=ON"
    "-DGTEST_INCLUDE_DIR=${lib.getDev gtest}/include"
    "-DGTEST_LIBRARY=${lib.getLib gtest}/lib/libgtest${libExt}"
    "-DGTEST_MAIN_LIBRARY=${lib.getLib gtest}/lib/libgtest_main${libExt}"
  ] ++ lib.optionals stdenv.hostPlatform.isAarch32 [
    "-DHWY_CMAKE_ARM7=ON"
  ] ++ lib.optionals stdenv.hostPlatform.isx86_32 [
    # Quoting CMakelists.txt:
    #   This must be set on 32-bit x86 with GCC < 13.1, otherwise math_test will be
    #   skipped. For GCC 13.1+, you can also build with -fexcess-precision=standard.
    # Fixes tests:
    #   HwyMathTestGroup/HwyMathTest.TestAllAtanh/EMU128
    #   HwyMathTestGroup/HwyMathTest.TestAllLog1p/EMU128
    "-DHWY_CMAKE_SSE2=ON"
  ] ++ lib.optionals stdenv.hostPlatform.isRiscV [
    # Runtime dispatch is not implemented https://github.com/google/highway/issues/838
    # so tests (and likely normal operation) fail with SIGILL on processors without V.
    # Until the issue is resolved, we disable RVV completely.
    "-DHWY_CMAKE_RVV=OFF"
  ];

  # hydra's darwin machines run into https://github.com/libjxl/libjxl/issues/408
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = with lib; {
    description = "Performance-portable, length-agnostic SIMD with runtime dispatch";
    homepage = "https://github.com/google/highway";
    license = with licenses; [ asl20 bsd3 ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
