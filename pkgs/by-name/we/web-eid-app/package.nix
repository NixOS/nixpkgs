{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gtest,
  pcsclite,
  pkg-config,
  qt6,
}:

stdenv.mkDerivation rec {
  pname = "web-eid-app";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "web-eid";
    repo = "web-eid-app";
    rev = "v${version}";
    hash = "sha256-wLZ6BABiukujKRAgwc6kHKSdXSsxxR9cdW5zSiP5zAE=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    gtest # required during build of lib/libelectronic-id/lib/libpcsc-cpp
    pcsclite
  ];

  meta = {
    description = "Signing and authentication operations with smart cards for the Web eID browser extension";
    mainProgram = "web-eid";
    longDescription = ''
      The Web eID application performs cryptographic digital signing and
      authentication operations with electronic ID smart cards for the Web eID
      browser extension (it is the [native messaging host](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/Native_messaging)
      for the extension). Also works standalone without the extension in command-line
      mode.
    '';
    homepage = "https://github.com/web-eid/web-eid-app";
    changelog = "https://github.com/web-eid/web-eid-app/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.flokli ];
    platforms = lib.platforms.linux;
  };
}
