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
  version = "12-unstable-2026-10-08";

  src = fetchFromGitHub {
    owner = "thpatch";
    repo = "thtk";
    rev = "917a3d3858850f01276b7fb5b9327e2c24d27d5b";
    hash = "sha256-cdOA66RRNRvE+LwbdEmKO7KYGQEQRGZ2OwWUHL0KwPU=";
  };

  # Required header files for the build phase
  env.NIX_CFLAGS_COMPILE = "-I${thtypes}";

  nativeBuildInputs = [
    cmake
    bison
    flex
    pkg-config
    validatePkgConfig
  ];

  buildInputs = [
    zlib
    libpng
    flex
    bison
  ];

  passthru = {
    updateScript = unstableGitUpdater { };
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  cmakeFlags = [
    (lib.cmakeBool "WITH_LIBPNG_SOURCE" false)
  ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Touhou Toolkit";
    homepage = "https://github.com/thpatch/thtk";
    changelog = "https://github.com/thpatch/thtk/releases";
    license = lib.licenses.bsd2;
    pkgConfigModules = [ "thtk" ];
    platforms = with lib.platforms; linux ++ windows;
    maintainers = with lib.maintainers; [
      theobori
      pagedMov
    ];
  };
})
