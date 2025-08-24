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
  libX11,
  libXau,
  libxcb,
  libXdmcp,
  libXrandr,
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
  version = "1.4.321.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Tools";
    rev = "vulkan-sdk-${version}";
    hash = "sha256-cd7aLDhXiZ4Wlnrx2dfCQG3j+9vosM3SeohhCNvVN48=";
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
    libX11
    libXau
    libxcb
    libXdmcp
    libXrandr
    wayland
    wayland-protocols
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    moltenvk
    moltenvk.dev
  ];

  libraryPath = lib.strings.makeLibraryPath [ vulkan-loader ];

  dontPatchELF = true;

  env.PKG_CONFIG_WAYLAND_SCANNER_WAYLAND_SCANNER = lib.getExe buildPackages.wayland-scanner;

  cmakeFlags = [
    # Temporarily disabled, see https://github.com/KhronosGroup/Vulkan-Tools/issues/1130
    # FIXME: remove when fixed upstream
    "-DBUILD_CUBE=OFF"
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

  meta = with lib; {
    description = "Khronos official Vulkan Tools and Utilities";
    longDescription = ''
      This project provides Vulkan tools and utilities that can assist
      development by enabling developers to verify their applications correct
      use of the Vulkan API.
    '';
    homepage = "https://github.com/KhronosGroup/Vulkan-Tools";
    platforms = platforms.unix;
    license = licenses.asl20;
    maintainers = [ maintainers.ralith ];
  };
}
