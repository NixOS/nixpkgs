{ lib
, stdenv
, fetchFromGitHub
, cmake
, python3
}:

stdenv.mkDerivation rec {
  pname = "catch2";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "catchorg";
    repo = "Catch2";
    rev = "v${version}";
    hash = "sha256-GcMkAgSfQnWs8wQeQD4ZMxJZED8V7FWBU04qMCutlPo=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DCATCH_DEVELOPMENT_BUILD=ON"
    "-DCATCH_BUILD_TESTING=${if doCheck then "ON" else "OFF"}"
  ];

  doCheck = true;

  checkInputs = [
    python3
  ];

  meta = {
    description = "Modern, C++-native, test framework for unit-tests";
    homepage = "https://github.com/catchorg/Catch2";
    changelog = "https://github.com/catchorg/Catch2/blob/${src.rev}/docs/release-notes.md";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ dotlambda ];
    platforms = lib.platforms.unix;
  };
}
