{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPackages,
  cmake,
  pkg-config,
  python3,
  glslang,
  libffi,
  libx11,
  libxau,
  libxcb,
  libxdmcp,
  libxrandr,
  vulkan-headers,
  vulkan-loader,
  vulkan-volk,
  wayland,
  wayland-protocols,
  wayland-scanner,
  moltenvk,
}:

stdenv.mkDerivation rec {
  pname = "vulkan-tools";
  version = "1.4.335";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Tools";
    rev = "vulkan-sdk-${version}";
    hash = "sha256-C/wzLLiG7DrLyP3YRKhjawNoEOCCogXkrFeBczeVZR0=";
  };

  patches = [ ./wayland-scanner.patch ];

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    wayland-scanner
  ];

  buildInputs = [
    glslang
    vulkan-headers
    vulkan-loader
    vulkan-volk
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libffi
    libx11
    libxau
    libxcb
    libxdmcp
    libxrandr
    wayland
    wayland-protocols
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    moltenvk
    moltenvk.dev
  ];

  libraryPath = lib.strings.makeLibraryPath [ vulkan-loader ];

  dontPatchELF = true;

  env.PKG_CONFIG_PATH = "${lib.getDev buildPackages.wayland-scanner}/lib/pkgconfig";

  cmakeFlags = [
    # Don't build the mock ICD as it may get used instead of other drivers, if installed
    "-DBUILD_ICD=OFF"
    # vulkaninfo loads libvulkan using dlopen, so we have to add it manually to RPATH
    "-DCMAKE_INSTALL_RPATH=${libraryPath}"
    "-DGLSLANG_INSTALL_DIR=${glslang}"
    # Hide dev warnings that are useless for packaging
    "-Wno-dev"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "-DMOLTENVK_REPO_ROOT=${moltenvk}/share/vulkan/icd.d"
    # Don’t build the cube demo because it requires `ibtool`, which is not available in nixpkgs.
    "-DBUILD_CUBE=OFF"
  ];

  meta = {
    description = "Khronos official Vulkan Tools and Utilities";
    longDescription = ''
      This project provides Vulkan tools and utilities that can assist
      development by enabling developers to verify their applications correct
      use of the Vulkan API.
    '';
    homepage = "https://github.com/KhronosGroup/Vulkan-Tools";
    platforms = lib.platforms.unix;
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.ralith ];
  };
}
