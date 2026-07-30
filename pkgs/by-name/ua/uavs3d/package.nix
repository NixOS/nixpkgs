{
  lib,
  fetchFromGitHub,
  cmake,
  stdenv,
  testers,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uavs3d";
  version = "1.1-unstable-2025-12-13";

  src = fetchFromGitHub {
    owner = "uavs3";
    repo = "uavs3d";
    rev = "0e20d2c291853f196c68922a264bcd8471d75b68";
    hash = "sha256-SlCGLglBsU3ua406Bnf89c4X80F5B93piF2sAXqtRus=";
  };

  cmakeFlags = [
    (lib.cmakeBool "COMPILE_10BIT" true)
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
  ];

  # Fix the build with CMake 4.
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'cmake_minimum_required(VERSION 3.1)' \
        'cmake_minimum_required(VERSION 3.10)'
  '';

  passthru = {
    updateScript = unstableGitUpdater {
      tagPrefix = "v";
    };
    tests.pkg-config = testers.hasPkgConfigModules { package = finalAttrs.finalPackage; };
  };

  meta = {
    homepage = "https://github.com/uavs3/uavs3d";
    description = "AVS3 decoder which supports AVS3-P2 baseline profile";
    license = lib.licenses.bsd3;
    pkgConfigModules = [ "uavs3d" ];
    maintainers = with lib.maintainers; [ jopejoe1 ];
    platforms = lib.platforms.all;
  };
})
