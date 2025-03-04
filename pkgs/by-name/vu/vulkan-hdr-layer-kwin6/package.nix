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

stdenv.mkDerivation rec {
  pname = "vulkan-hdr-layer-kwin6";
  version = "0-unstable-2025-02-13";

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
    rev = "1f13469feb0704bcf56b64fd6ec3793e5087d895";
    hash = "sha256-5WfkIATcwecr+ioI4GfQQ34G0jWLctZ4oBlSFqw6UE8=";
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
