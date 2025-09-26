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
  version = "0.27.1";

  src = fetchFromGitHub {
    owner = "xtensor-stack";
    repo = "xtensor";
    tag = finalAttrs.version;
    hash = "sha256-bvy2nF368rtVwUfGgSE1Zmpcze1nPwUbskXbf8flPt4=";
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

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  nativeCheckInputs = [
    doctest
  ];
  checkTarget = "xtest";

  meta = {
    description = "Multi-dimensional arrays with broadcasting and lazy computing";
    homepage = "https://github.com/xtensor-stack/xtensor";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ cpcloud ];
    platforms = lib.platforms.all;
  };
})
