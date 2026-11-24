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
  version = "1.1.17";

  src = fetchFromGitHub {
    owner = "vsg-dev";
    repo = "VulkanSceneGraph";
    tag = "v${finalAttrs.version}";
    hash = "sha256-irEWIyk0MMh0BE7FmWdkzdzn2QCO0ASYzYUbouPJcKs=";
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
