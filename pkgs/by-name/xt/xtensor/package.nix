{
  lib,
  stdenv,
  fetchFromGitHub,
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
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "xtensor-stack";
    repo = "xtensor";
    rev = finalAttrs.version;
    hash = "sha256-hVfdtYcJ6mzqj0AUu6QF9aVKQGYKd45RngY6UN3yOH4=";
  };

  nativeBuildInputs = [
    cmake
  ];
  propagatedBuildInputs = [
    nlohmann_json
    xtl
    xsimd
  ];

  cmakeFlags = [
    # Always build the tests, even if not running them, because testing whether
    # they can be built is a test in itself.
    (lib.cmakeBool "BUILD_TESTS" true)
    (lib.cmakeBool "XTENSOR_ENABLE_ASSERT" enableAssertions)
    (lib.cmakeBool "XTENSOR_CHECK_DIMENSION" enableBoundChecks)
  ];

  doCheck = true;
  nativeCheckInputs = [
    doctest
  ];
  checkTarget = "xtest";

  meta = with lib; {
    description = "Multi-dimensional arrays with broadcasting and lazy computing";
    homepage = "https://github.com/xtensor-stack/xtensor";
    license = licenses.bsd3;
    maintainers = with maintainers; [ cpcloud ];
    platforms = platforms.all;
  };
})
