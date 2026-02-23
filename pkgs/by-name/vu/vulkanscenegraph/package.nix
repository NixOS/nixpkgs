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
  version = "1.1.13";

  src = fetchFromGitHub {
    owner = "vsg-dev";
    repo = "VulkanSceneGraph";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6Jxk94GPUaPxcv4dHTQKnE7n8b/2neG2Mrv94vc9ckU=";
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
