{ lib
, stdenv
, fetchFromGitHub
, cmake
, python3
}:

stdenv.mkDerivation rec {
  pname = "catch2";
  version = "3.5.2";

  src = fetchFromGitHub {
    owner = "catchorg";
    repo = "Catch2";
    rev = "v${version}";
    hash = "sha256-xGPfXjk+oOnR7JqTrZd2pKJxalrlS8CMs7HWDClXaS8=";
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

  # Tests fail on x86_32 if compiled with x87 floats: https://github.com/catchorg/Catch2/issues/2796
  env = lib.optionalAttrs stdenv.isx86_32 {
    NIX_CFLAGS_COMPILE = "-msse2 -mfpmath=sse";
  };

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
