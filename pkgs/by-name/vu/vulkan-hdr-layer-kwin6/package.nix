{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  libx11,
  meson,
  ninja,
  pkg-config,
  unstableGitUpdater,
  vulkan-headers,
  vulkan-loader,
  wayland-scanner,
  wayland,
}:

stdenv.mkDerivation {
  pname = "vulkan-hdr-layer-kwin6";
  version = "0-unstable-2026-08-05";

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    cmake
    wayland-scanner
  ];

  buildInputs = [
    vulkan-headers
    vulkan-loader
    libx11
    wayland
  ];

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Zamundaaa";
    repo = "VK_hdr_layer";
    rev = "8ec9b54d21f7474a9c406cf7366598a298d145f7";
    hash = "sha256-gD+BOfM/2QN0UxhlVZNgsHCgIJkGZppHfM1ONsnMe2U=";
    fetchSubmodules = true;
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Vulkan Wayland HDR WSI Layer (Xaver Hugl's fork for KWin 6)";
    homepage = "https://github.com/Zamundaaa/VK_hdr_layer";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ d4rk ];
  };
}
