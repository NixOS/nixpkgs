{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  glslang,
  libxcb,
  vulkan-headers,
  vulkan-loader,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vulkanscenegraph";
  version = "1.1.12";

  src = fetchFromGitHub {
    owner = "vsg-dev";
    repo = "VulkanSceneGraph";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DdTfn8URLJkF5Nhkl8ZCq+brKK/T+9FipaeTON4Dsfw=";
  };

  patches = [
    # make it compatible with glslang 16.x
    (fetchpatch {
      url = "https://github.com/vsg-dev/VulkanSceneGraph/commit/313865d420bba7bb3327460c367c7526f566a74e.patch";
      hash = "sha256-hytv79AE70S/yBiI+n9RHGbHmYZW5388BiFh9l1auzU=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    glslang
    libxcb
    vulkan-headers
    vulkan-loader
  ];

  meta = {
    description = "Vulkan & C++17 based Scene Graph Project";
    homepage = "https://www.vulkanscenegraph.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.unix;
  };
})
