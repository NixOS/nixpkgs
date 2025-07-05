{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  doctest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xsimd";
  version = "13.2.0";

  src = fetchFromGitHub {
    owner = "xtensor-stack";
    repo = "xsimd";
    tag = finalAttrs.version;
    hash = "sha256-L4ttJxP46uNwQAEUMoJ8rsc51Le2GeIGbT1kX7ZzcPA=";
  };

  patches = lib.optionals stdenv.hostPlatform.isDarwin [
    # https://github.com/xtensor-stack/xsimd/issues/1030
    ./disable-test_error_gamma.patch

    # https://github.com/xtensor-stack/xsimd/issues/1063
    ./relax-asin-precision.diff
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
