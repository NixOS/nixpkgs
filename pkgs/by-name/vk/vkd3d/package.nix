{
  lib,
  autoreconfHook,
  bison,
  fetchFromGitLab,
  flex,
  pkg-config,
  spirv-headers,
  stdenv,
  vulkan-headers,
  vulkan-loader,
  wine,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vkd3d";
  version = "1.13";

  src = fetchFromGitLab {
    domain = "gitlab.winehq.org";
    owner = "wine";
    repo = "vkd3d";
    rev = "vkd3d-${finalAttrs.version}";
    hash = "sha256-5G+cdK3rJWlEbJN7uPspPyTtjVk4v/sTg134tZo1CTI=";
  };

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    pkg-config
    wine
  ];

  buildInputs = [
    spirv-headers
    vulkan-headers
    vulkan-loader
  ];

  strictDeps = true;

  meta = {
    homepage = "https://gitlab.winehq.org/wine/vkd3d";
    description = "Direct3D to Vulkan translation library";
    longDescription = ''
      Vkd3d is a 3D graphics library built on top of Vulkan. It has an API very
      similar, but not identical, to Direct3D 12.

      Vkd3d can be used by projects that target Direct3D 12 as a drop-in
      replacement at build-time with some modest source modifications.

      If vkd3d is available when building Wine, then Wine will use it to support
      Direct3D 12 applications.
    '';
    license = with lib.licenses; [ lgpl21Plus ];
    mainProgram = "vkd3d-compiler";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    inherit (wine.meta) platforms;
  };
})
