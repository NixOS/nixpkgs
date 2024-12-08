{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  libX11,
  meson,
  ninja,
  pkg-config,
  vulkan-headers,
  vulkan-loader,
  wayland-scanner,
  wayland,
}:

stdenv.mkDerivation rec {
  pname = "vulkan-hdr-layer-kwin6";
  version = "0-unstable-2024-10-19";

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
    rev = "e173f2617262664901039e3c821929afce05d2c1";
    hash = "sha256-hBxRwbn29zFeHcRpfMF6I4piSASpN2AvZY0ci5Utj4U=";
    fetchSubmodules = true;
  };

  meta = {
    description = "Vulkan Wayland HDR WSI Layer (Xaver Hugl's fork for KWin 6)";
    homepage = "https://github.com/Zamundaaa/VK_hdr_layer";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ d4rk ];
  };
}
