{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  flex,
  bison,
  pkg-config,
  zlib,
  libpng,
  unstableGitUpdater,
  validatePkgConfig,
  testers,
}:
let
  thtypes = fetchFromGitHub {
    owner = "thpatch";
    repo = "thtypes";
    rev = "29ed7d6e1db555ad15fd29edcc0763754ad5b764";
    hash = "sha256-j3lrToLuS7SbzzdL3/8uB0nL1z04GtmfmKIC/v37jwI=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "thtk";
  version = "12-unstable-2024-11-12";

  src = fetchFromGitHub {
    owner = "thpatch";
    repo = "thtk";
    rev = "1e38aeed98f3bad09d2583ca05bfe0ba9c13c1db";
    hash = "sha256-Ju38XrdTZk6l0HmNYG3vSE1TjHQbESw7UuPINlmozlo=";
  };

  # Required header files for the build phase
  env.NIX_CFLAGS_COMPILE = "-I${thtypes}";

  nativeBuildInputs = [
    cmake
    pkg-config
    validatePkgConfig
  ];

  buildInputs = [
    zlib
    libpng
    flex
    bison
  ];

  patches = [
    ./thtk_pkg_config.patch
  ];

  passthru = {
    updateScript = unstableGitUpdater { };
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  cmakeFlags = [
    (lib.cmakeBool "WITH_LIBPNG_SOURCE" false)
  ];

  meta = {
    description = "Touhou Toolkit";
    homepage = "https://github.com/thpatch/thtk";
    changelog = "https://github.com/thpatch/thtk/releases";
    license = lib.licenses.bsd2;
    pkgConfigModules = [ "thtk" ];
    platforms = with lib.platforms; linux ++ windows;
    maintainers = with lib.maintainers; [ theobori ];
  };
})
