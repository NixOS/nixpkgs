{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libX11,
  libxcb,
  libXrandr,
  wayland,
  moltenvk,
  vulkan-headers,
  addDriverRunpath,
  enableX11 ? stdenv.hostPlatform.isLinux,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vulkan-loader";
  version = "1.4.321.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Loader";
    rev = "vulkan-sdk-${finalAttrs.version}";
    hash = "sha256-i06il1GRkjSlhY36XpIUCcd1Wy+If+Eennzbb//1dzk=";
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
    libX11
    libxcb
    libXrandr
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

  meta = with lib; {
    description = "LunarG Vulkan loader";
    homepage = "https://www.lunarg.com";
    platforms = platforms.unix ++ platforms.windows;
    license = licenses.asl20;
    maintainers = [ maintainers.ralith ];
    broken = finalAttrs.version != vulkan-headers.version;
    pkgConfigModules = [ "vulkan" ];
  };
})
