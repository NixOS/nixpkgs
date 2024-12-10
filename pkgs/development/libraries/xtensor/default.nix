{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  doctest,
  enableAssertions ? false,
  enableBoundChecks ? false, # Broadcasts don't pass bound checks
  nlohmann_json,
  xtl,
  xsimd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xtensor";
  version = "0.24.7";

  src = fetchFromGitHub {
    owner = "xtensor-stack";
    repo = "xtensor";
    rev = finalAttrs.version;
    hash = "sha256-dVbpcBW+jK9nIl5efk5LdKdBm8CkaJWEZ0ZY7ZuApwk=";
  };
  patches = [
    # Support for xsimd 11
    (fetchpatch {
      url = "https://github.com/xtensor-stack/xtensor/commit/77a650a8018e0be6fcc76bf66685ff352ae23ef1.patch";
      hash = "sha256-vOdUzzsSK+lYcA7fZXWOTVV202GZC0DhkMMjzggnmWE=";
    })
    # A single test fails on Darwin, see:
    # https://github.com/xtensor-stack/xtensor/issues/2718
    ./remove-failing-test_xinfo.patch
  ];

  nativeBuildInputs = [
    cmake
  ];
  propagatedBuildInputs =
    [
      nlohmann_json
      xtl
    ]
    ++ lib.optionals (!(stdenv.isAarch64 && stdenv.isLinux)) [
      # xsimd support is broken on aarch64-linux, see:
      # https://github.com/xtensor-stack/xsimd/issues/945
      xsimd
    ];

  cmakeFlags =
    let
      cmakeBool = x: if x then "ON" else "OFF";
    in
    [
      "-DBUILD_TESTS=${cmakeBool finalAttrs.finalPackage.doCheck}"
      "-DXTENSOR_ENABLE_ASSERT=${cmakeBool enableAssertions}"
      "-DXTENSOR_CHECK_DIMENSION=${cmakeBool enableBoundChecks}"
    ];

  doCheck = true;
  nativeCheckInputs = [
    doctest
  ];
  checkTarget = "xtest";

  meta = with lib; {
    description = "Multi-dimensional arrays with broadcasting and lazy computing.";
    homepage = "https://github.com/xtensor-stack/xtensor";
    license = licenses.bsd3;
    maintainers = with maintainers; [ cpcloud ];
    platforms = platforms.all;
  };
})
