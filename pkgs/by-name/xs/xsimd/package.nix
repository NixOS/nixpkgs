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
  version = "13.0.0";
  src = fetchFromGitHub {
    owner = "xtensor-stack";
    repo = "xsimd";
    rev = finalAttrs.version;
    hash = "sha256-qElJYW5QDj3s59L3NgZj5zkhnUMzIP2mBa1sPks3/CE=";
  };
  patches =
    [
      # Fix of https://github.com/xtensor-stack/xsimd/pull/1024 for
      # https://github.com/xtensor-stack/xsimd/issues/456 and
      # https://github.com/xtensor-stack/xsimd/issues/807,
      (fetchpatch {
        url = "https://github.com/xtensor-stack/xsimd/commit/c8a87ed6e04b6782f48f94713adfb0cad6c11ddf.patch";
        hash = "sha256-2/FvBGdqTPcayD7rdHPSzL+F8IYKAfMW0WBJ0cW9EZ0=";
      })
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
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

  meta = with lib; {
    changelog = "https://github.com/xtensor-stack/xsimd/blob/${finalAttrs.version}/Changelog.rst#${
      builtins.replaceStrings [ "." ] [ "" ] finalAttrs.version
    }";
    description = "C++ wrappers for SIMD intrinsics";
    homepage = "https://github.com/xtensor-stack/xsimd";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      tobim
      doronbehar
    ];
    platforms = platforms.all;
  };
})
