{ lib
, stdenv
, fetchFromGitHub
, cmake
, doctest
, enableAssertions ? false
, enableBoundChecks ? false # Broadcasts don't pass bound checks
, nlohmann_json
, xtl
# We don't support xsimd yet due to:
# https://github.com/xtensor-stack/xtensor/issues/2721
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

  nativeBuildInputs = [
    cmake
  ];
  propagatedBuildInputs = [
    nlohmann_json
    xtl
  ];

  cmakeFlags = let
    cmakeBool = x: if x then "ON" else "OFF";
  in [
    "-DBUILD_TESTS=${cmakeBool finalAttrs.doCheck}"
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
