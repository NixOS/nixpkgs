{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, wayland-scanner
, wrapQtAppsHook
, qtbase
, qtdeclarative
, qwlroots
, wayland
, wayland-protocols
, wlr-protocols
, pixman
, libdrm
, libinput
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "waylib";
  version = "0.3.0-alpha";

  src = fetchFromGitHub {
    owner = "vioken";
    repo = "waylib";
    rev = finalAttrs.version;
    hash = "sha256-5IWe8VFpLwDSja4to/ugVS80s5+bcAbM6/fg1HPP52Q=";
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

  outputs = [ "out" "dev" ];

  meta = {
    description = "Wrapper for wlroots based on Qt";
    homepage = "https://github.com/vioken/waylib";
    license = with lib.licenses; [ gpl3Only lgpl3Only asl20 ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ rewine ];
  };
})

