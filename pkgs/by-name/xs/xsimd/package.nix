{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  doctest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xsimd";
  version = "14.0.0";

  src = fetchFromGitHub {
    owner = "xtensor-stack";
    repo = "xsimd";
    tag = finalAttrs.version;
    hash = "sha256-ijNoHb6xC+OHJbUB4j1PRsoHMzjrnOHVoDRe/nKguDo=";
  };

  patches = [
    # See: https://github.com/xtensor-stack/xsimd/issues/1030
    #
    # NOTE: Although the patch is needed only on Darwin, it is safer to always
    # include it, to avoid a situation an linux user trying to update the
    # package fails to notice it doesn't apply on their platform. We prefer not
    # performing this test on linux platforms too although it should pass.
    ./disable-test_error_gamma.patch
    # https://github.com/xtensor-stack/xsimd/issues/1232#issuecomment-3712243289
    (fetchpatch {
      url = "https://github.com/xtensor-stack/xsimd/commit/eb17eaaa30129a65042bedf245658014ffd94232.patch";
      hash = "sha256-619uFD5FijtX5I7fyoaBl/8g2jbDVaSETDMUkyYIFSs=";
      revert = true;
    })
  ];

  # strictDeps raises the chance that xsimd will be able to be cross compiled
  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    doctest
  ];

  cmakeFlags = [
    # Always build the tests, even if not running them, because testing whether
    # they can be built is a test in itself.
    "-DBUILD_TESTS=ON"
  ];

  doCheck = true;
  checkTarget = "xtest";

  meta = {
    changelog = "https://github.com/xtensor-stack/xsimd/blob/${finalAttrs.version}/Changelog.rst#${
      builtins.replaceStrings [ "." ] [ "" ] finalAttrs.version
    }";
    description = "C++ wrappers for SIMD intrinsics";
    homepage = "https://github.com/xtensor-stack/xsimd";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      tobim
      doronbehar
    ];
    platforms = lib.platforms.all;
  };
})
