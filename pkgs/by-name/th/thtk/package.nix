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
  version = "12-unstable-2025-05-06";

  src = fetchFromGitHub {
    owner = "thpatch";
    repo = "thtk";
    rev = "97dc32f48efb704a131acff4a18bc401b0662748";
    hash = "sha256-rgSl5VEMQkxMAhg1cMW/c9hH64MZJQ7WxqGsOYiANPM=";
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

  passthru = {
    updateScript = unstableGitUpdater { };
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  cmakeFlags = [
    (lib.cmakeBool "WITH_LIBPNG_SOURCE" false)
  ];

  postInstall = ''
    # Substitute includedir and libdir bad path prefix
    substituteInPlace "$out/lib/pkgconfig/thtk.pc" \
      --replace-fail "//nix" "/nix"
  '';

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
