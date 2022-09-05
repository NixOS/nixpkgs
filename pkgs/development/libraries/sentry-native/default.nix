{ lib, stdenv, fetchFromGitHub, cmake, curl, breakpad, pkg-config }:

stdenv.mkDerivation rec {
  pname = "sentry-native";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "sentry-native";
    rev = version;
    sha256 = "sha256-whbzoKIYLwj4yoFaT3frghJd/WzfpolSAuZzQRtnP5E=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ curl breakpad pkg-config ];
  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=RelWithDebInfo"
    "-DSENTRY_BREAKPAD_SYSTEM=On"
  ];

  meta = with lib; {
    homepage = "https://github.com/getsentry/sentry-native";
    description = "Sentry SDK for C, C++ and native applications.";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wheelsandmetal ];
  };
}
