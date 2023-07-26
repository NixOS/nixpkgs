{ lib, stdenv, cmake, ninja, gtest, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "libhwy";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "google";
    repo = "highway";
    rev = version;
    hash = "sha256-Gym2iHq5ws9kuG4HWSQndD8hVugV4USZt6dUFnEkLwY=";
  };
  patches = [
    # backport for compilation issue on aarch64
    # https://github.com/google/highway/issues/1613
    (fetchpatch {
      url = "https://github.com/google/highway/commit/7ad89efa911cb906ccf3f78fe510db415e921801.diff";
      hash = "sha256-hTSkeCh2QLMqeIKG/CAqJXaPqD/66Z02gjGXk591f+U=";
    })
  ];

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
  ];

  # hydra's darwin machines run into https://github.com/libjxl/libjxl/issues/408
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = with lib; {
    description = "Performance-portable, length-agnostic SIMD with runtime dispatch";
    homepage = "https://github.com/google/highway";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
