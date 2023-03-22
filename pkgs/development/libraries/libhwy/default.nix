{ lib, stdenv, cmake, ninja, gtest, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "libhwy";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "google";
    repo = "highway";
    rev = version;
    hash = "sha256-bQtfye+gn7GOyzCtji4st5hsV40rPzuaYDP7N1tZ8wg=";
  };

  nativeBuildInputs = [ cmake ninja ];

  # Required for case-insensitive filesystems ("BUILD" exists)
  dontUseCmakeBuildDir = true;

  cmakeFlags = let
    libExt = stdenv.hostPlatform.extensions.sharedLibrary;
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
