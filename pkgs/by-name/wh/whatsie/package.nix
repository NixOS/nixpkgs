{
  fetchFromGitHub,
  lib,
  stdenv,
  cmake,
  libx11,
  libxcb,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "whatsie";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "keshavbhatt";
    repo = "whatsie";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-tSBbEwc5+tALBmqB8E9kW25hdS8pXtjIgee8+SDMrSY=";
  };

  buildInputs = [
    libx11
    libxcb
    qt6.qtwebengine
  ];

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  strictDeps = true;

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/keshavbhatt/whatsie";
    description = "Feature rich WhatsApp Client for Desktop Linux";
    license = lib.licenses.mit;
    mainProgram = "whatsie";
    maintainers = with lib.maintainers; [ ajgon ];
    platforms = lib.platforms.linux;
  };
})
