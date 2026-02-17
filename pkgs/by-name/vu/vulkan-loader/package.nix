{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libx11,
  libxcb,
  libxrandr,
  wayland,
  moltenvk,
  vulkan-headers,
  addDriverRunpath,
  enableX11 ? stdenv.hostPlatform.isLinux,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vulkan-loader";
  version = "1.4.335.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Loader";
    rev = "vulkan-sdk-${finalAttrs.version}";
    hash = "sha256-1xLT4AynJumzwkYOBS5i0OpCi3EdE8QctctDn+DGrvU=";
  };

  patches = [ ./fix-pkgconfig.patch ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    vulkan-headers
  ]
  ++ lib.optionals enableX11 [
    libx11
    libxcb
    libxrandr
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wayland
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_INCLUDEDIR=${vulkan-headers}/include"
    (lib.cmakeBool "BUILD_WSI_XCB_SUPPORT" enableX11)
    (lib.cmakeBool "BUILD_WSI_XLIB_SUPPORT" enableX11)
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin "-DSYSCONFDIR=${moltenvk}/share"
  ++ lib.optional stdenv.hostPlatform.isLinux "-DSYSCONFDIR=${addDriverRunpath.driverLink}/share"
  ++ lib.optional (stdenv.buildPlatform != stdenv.hostPlatform) "-DUSE_GAS=OFF";

  outputs = [
    "out"
    "dev"
  ];

  doInstallCheck = true;

  installCheckPhase = ''
    grep -q "${vulkan-headers}/include" $dev/lib/pkgconfig/vulkan.pc || {
      echo vulkan-headers include directory not found in pkg-config file
      exit 1
    }
  '';

  passthru = {
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "LunarG Vulkan loader";
    homepage = "https://www.lunarg.com";
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.ralith ];
    broken = finalAttrs.version != vulkan-headers.version;
    pkgConfigModules = [ "vulkan" ];
  };
})
