# The Darwin build of Mesa is different enough that we just give it an entire separate expression.
{
  lib,
  stdenv,
  fetchFromGitLab,
  apple-sdk_26,
  bison,
  darwinMinVersionHook,
  flex,
  glslang,
  libpng,
  libxml2,
  llvmPackages,
  meson,
  ninja,
  pkg-config,
  python3Packages,
  libxfixes,
  libxext,
  libx11,
  libxcb,
  libxshmfence,
  spirv-llvm-translator,
  spirv-tools,
  zlib,
  eglPlatforms ? [
    "macos"
    "x11"
  ],
  galliumDrivers ? [
    "llvmpipe" # software renderer
    "softpipe" # older software renderer
  ],
  vulkanDrivers ? [
    "kosmickrisp" # Vulkan on Metal
  ],
  vulkanLayers ? [
    "anti-lag"
    "intel-nullhw"
    "overlay"
    "screenshot"
    "vram-report-limit"
  ],
}:

let
  common = import ./common.nix { inherit lib fetchFromGitLab; };
in
stdenv.mkDerivation {
  inherit (common)
    pname
    version
    src
    meta
    ;

  patches = [
    # Required to build KosmicKrisp
    ./opencl.patch
  ];

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    bison
    flex
    # Use bin output from glslang to not propagate the dev output at
    # the build time with the host glslang.
    (lib.getBin glslang)
    meson
    ninja
    pkg-config
    python3Packages.packaging
    python3Packages.python
    python3Packages.mako
    python3Packages.pyyaml
  ];

  buildInputs = [
    apple-sdk_26 # KosmicKrisp requires Metal 4 to build, but …
    (darwinMinVersionHook "15.0") # … it supports back to Metal 3.2, which requires macOS 15.
    libpng
    libxml2 # should be propagated from libllvm
    llvmPackages.libclang
    llvmPackages.libclc
    llvmPackages.libllvm
    python3Packages.python # for shebang
    spirv-llvm-translator
    spirv-tools
    libx11
    libxext
    libxfixes
    libxcb
    libxshmfence
    zlib
  ];

  mesonAutoFeatures = "disabled";

  mesonFlags = [
    "--sysconfdir=/etc"
    "--datadir=${placeholder "out"}/share"

    # What to build
    (lib.mesonOption "platforms" (lib.concatStringsSep "," eglPlatforms))
    (lib.mesonOption "gallium-drivers" (lib.concatStringsSep "," galliumDrivers))
    (lib.mesonOption "vulkan-drivers" (lib.concatStringsSep "," vulkanDrivers))
    (lib.mesonOption "vulkan-layers" (lib.concatStringsSep "," vulkanLayers))

    # Disable glvnd on Darwin
    (lib.mesonEnable "glvnd" false)
    (lib.mesonEnable "gbm" false)
    (lib.mesonBool "libgbm-external" false)

    # Needed for KosmicKrisp
    (lib.mesonOption "clang-libdir" "${lib.getLib llvmPackages.libclang}/lib")
    (lib.mesonEnable "llvm" true)
    (lib.mesonEnable "shared-llvm" true)
    (lib.mesonEnable "spirv-tools" true)

    # Needed for Apple GLX support
    (lib.mesonOption "glx" "dri")
  ];

  mesonBuildType = "release";

  passthru = {
    # needed to pass evaluation of bad platforms
    driverLink = throw "driverLink not supported on darwin";
    # Don't need this on Darwin.
    llvmpipeHook = null;
  };

}
