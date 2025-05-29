{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  libX11,
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
  version = "0-unstable-2025-05-22";

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
    libX11
    wayland
  ];

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Zamundaaa";
    repo = "VK_hdr_layer";
    rev = "1384036ea24a9bc38a5c684dac5122d5e3431ae6";
    hash = "sha256-xm0S1vLE8MAov8gf6rN5ZKZAe6NMKfHDlUlmNd332qw=";
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
