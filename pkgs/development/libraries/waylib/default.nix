{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wayland-scanner,
  wrapQtAppsHook,
  qtbase,
  qtdeclarative,
  qwlroots,
  wayland,
  wayland-protocols,
  wlr-protocols,
  pixman,
  libdrm,
  libinput,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "waylib";
  version = "0.6.10-alpha";

  src = fetchFromGitHub {
    owner = "vioken";
    repo = "waylib";
    rev = finalAttrs.version;
    hash = "sha256-cs4nPYMIOppVuna5qBbgGtPdmVhMrhKkVG7L09NmB/U=";
  };

  depsBuildBuild = [
    # To find wayland-scanner
    pkg-config
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    qtbase
    qtdeclarative
    qwlroots
    wayland
    wayland-protocols
    wlr-protocols
    pixman
    libdrm
    libinput
  ];

  strictDeps = true;

  dontWrapQtApps = true;

  outputs = [
    "out"
    "dev"
  ];

  meta = {
    description = "Wrapper for wlroots based on Qt";
    homepage = "https://github.com/vioken/waylib";
    license = with lib.licenses; [
      gpl3Only
      lgpl3Only
      asl20
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ rewine ];
  };
})
