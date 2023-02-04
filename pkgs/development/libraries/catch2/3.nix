{ lib
, stdenv
, fetchFromGitHub
, cmake
, python3
}:

stdenv.mkDerivation rec {
  pname = "catch2";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "catchorg";
    repo = "Catch2";
    rev = "v${version}";
    hash = "sha256-JVxBYhKTejc8lfqgxz5Ig5G9H90YuIcGAUopGJG/3Dg=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DCATCH_DEVELOPMENT_BUILD=ON"
    "-DCATCH_BUILD_TESTING=${if doCheck then "ON" else "OFF"}"
  ] ++ lib.optionals (stdenv.isDarwin && doCheck) [
    # test has a faulty path normalization technique that won't work in
    # our darwin build environment https://github.com/catchorg/Catch2/issues/1691
    "-DCMAKE_CTEST_ARGUMENTS=-E;ApprovalTests"
  ];

  doCheck = true;

  nativeCheckInputs = [
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
