{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  glfw3,
  libX11,
  libXau,
  libXdmcp,
  libepoxy,
  libffi,
  libxcb,
  pkg-config,
  wayland,
  wayland-scanner,
}:

stdenv.mkDerivation {
  pname = "wlay";
  version = "unstable-2022-01-26";

  src = fetchFromGitHub {
    owner = "atx";
    repo = "wlay";
    rev = "ed316060ac3ac122c0d3d8918293e19dfe9a6c90";
    hash = "sha256-Lu+EyoDHiXK9QzD4jdwbllCOCl2aEU+uK6/KxC2AUGQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    extra-cmake-modules
    glfw3
    libX11
    libXau
    libXdmcp
    libepoxy
    libffi
    libxcb
    wayland
  ];

  strictDeps = true;

  meta = {
    homepage = "https://github.com/atx/wlay";
    description = "Graphical output management for Wayland";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    inherit (wayland.meta) platforms;
    mainProgram = "wlay";
  };
}
