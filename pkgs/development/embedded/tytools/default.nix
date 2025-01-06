{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wrapQtAppsHook,
  qtbase,
}:

stdenv.mkDerivation rec {
  pname = "tytools";
  version = "0.9.8";

  src = fetchFromGitHub {
    owner = "Koromix";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-MKhh0ooDZI1Ks8vVuPRiHhpOqStetGaAhE2ulvBstxA=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];
  buildInputs = [
    qtbase
  ];

  meta = {
    description = "Collection of tools to manage Teensy boards";
    homepage = "https://koromix.dev/tytools";
    license = lib.licenses.unlicense;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ahuzik ];
  };
}
