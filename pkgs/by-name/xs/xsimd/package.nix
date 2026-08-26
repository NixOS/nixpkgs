{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  doctest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xsimd";
  version = "14.3.0";

  src = fetchFromGitHub {
    owner = "xtensor-stack";
    repo = "xsimd";
    tag = finalAttrs.version;
    hash = "sha256-0m9gUDCgGh58lf9uPp1Obw4rsqWEL1RffWYB6s315p0=";
  };

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
