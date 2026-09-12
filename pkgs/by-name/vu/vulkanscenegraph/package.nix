{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  glslang,
  libxcb,
  vulkan-headers,
  vulkan-loader,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vulkanscenegraph";
  version = "1.1.16";

  src = fetchFromGitHub {
    owner = "vsg-dev";
    repo = "VulkanSceneGraph";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rNnSLRbFi7gWu6ZQ+7xxeF4F8xD4Bdh9fojj+7Ta1A0=";
  };

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
