{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, static ? stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation rec {
  pname = "gtest";
  version = "1.14.0";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "v${version}";
    hash = "sha256-t0RchAHTJbuI5YW4uyBPykTvcjy90JW9AOPNjIhwh6U=";
  };

  patches = [
    ./fix-cmake-config-includedir.patch
  ];

  nativeBuildInputs = [ cmake ninja ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=${if static then "OFF" else "ON"}"
  ] ++ lib.optionals (
    (stdenv.cc.isGNU && (lib.versionOlder stdenv.cc.version "11.0"))
    || (stdenv.cc.isClang && (lib.versionOlder stdenv.cc.version "16.0"))
  ) [
    # Enable C++17 support
    # https://github.com/google/googletest/issues/3081
    "-DCMAKE_CXX_STANDARD=17"
  ];

  meta = with lib; {
    description = "Google's framework for writing C++ tests";
    homepage = "https://github.com/google/googletest";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ ivan-tkatchev ];
  };
}
