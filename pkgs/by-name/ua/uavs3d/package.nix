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
  version = "1.1-unstable-2023-02-23";

  src = fetchFromGitHub {
    owner = "uavs3";
    repo = "uavs3d";
    rev = "1fd04917cff50fac72ae23e45f82ca6fd9130bd8";
    hash = "sha256-ZSuFgTngOd4NbZnOnw4XVocv4nAR9HPkb6rP2SASLrM=";
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

  passthru = {
    updateScript = unstableGitUpdater { };
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
