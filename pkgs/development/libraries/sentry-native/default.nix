{ lib
, stdenv
, fetchFromGitHub
, cmake
, curl
, breakpad
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "sentry-native";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "sentry-native";
    rev = version;
    hash = "sha256-I4++of7P8AwTMh48UM+yXjbNykYwJJg1Y8bpGKKAicA=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    curl
    breakpad
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=RelWithDebInfo"
    "-DSENTRY_BREAKPAD_SYSTEM=On"
  ];

  meta = with lib; {
    homepage = "https://github.com/getsentry/sentry-native";
    description = "Sentry SDK for C, C++ and native applications";
    changelog = "https://github.com/getsentry/sentry-native/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wheelsandmetal ];
  };
}
