{
  lib,
  stdenv,
  cmake,
  fetchgit,
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
  version = "0.1.0";

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    cmake
  ];

  buildInputs = [
    vulkan-headers
    vulkan-loader
    libX11
    wayland-scanner
    wayland
  ];

  src = fetchgit {
    url = "https://github.com/Zamundaaa/VK_hdr_layer.git";
    rev = "e47dc6d";
    hash = "sha256-qy1faOE4eHnHHiNnhdXroCi2FKGezYoHkg0kufFBMhM=";
    fetchSubmodules = true;
  };

  meta = with lib; {
    description = "Vulkan Wayland HDR WSI Layer (Xaver Hugl's fork for KWin 6)";
    homepage = "https://github.com/Zamundaaa/VK_hdr_layer";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ d4rk ];
  };
}
