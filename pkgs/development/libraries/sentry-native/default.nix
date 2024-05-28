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
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "sentry-native";
    rev = version;
    hash = "sha256-vmoBTFhSSYMzbjQIGTCvMvOvVv+2y23RZx589rMR5bs=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    curl
    breakpad
  ];

  cmakeBuildType = "RelWithDebInfo";

  cmakeFlags = [
    "-DSENTRY_BREAKPAD_SYSTEM=On"
    "-DSENTRY_BACKEND=breakpad"
  ];

  meta = with lib; {
    homepage = "https://github.com/getsentry/sentry-native";
    description = "Sentry SDK for C, C++ and native applications";
    changelog = "https://github.com/getsentry/sentry-native/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wheelsandmetal daniel-fahey ];
  };
}
