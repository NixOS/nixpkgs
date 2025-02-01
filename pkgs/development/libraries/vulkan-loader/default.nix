{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, pkg-config, libX11, libxcb
, libXrandr, wayland, moltenvk, vulkan-headers, addDriverRunpath
, testers }:

stdenv.mkDerivation (finalAttrs: {
  pname = "vulkan-loader";
  version = "1.3.290.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Loader";
    rev = "vulkan-sdk-${finalAttrs.version}";
    hash = "sha256-z26xvp7bKaOQAXF+/Sk24Syuw3N9QXc6sk2vlQwceJ8=";
  };

  patches = [ ./fix-pkgconfig.patch ]
    ++ lib.optionals stdenv.is32bit [
      # Backport patch to support 64-bit inodes on 32-bit systems
      # FIXME: remove in next update
      (fetchpatch {
        url = "https://github.com/KhronosGroup/Vulkan-Loader/commit/ecd88b5c6b1e4c072c55c8652d76513d74c5ad4e.patch";
        hash = "sha256-Ea+v+RfmVl8fRbkr2ETM3/7R4vp+jw7hvTq2hnw4V/0=";
      })
    ];

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ vulkan-headers ]
    ++ lib.optionals stdenv.isLinux [ libX11 libxcb libXrandr wayland ];

  cmakeFlags = [ "-DCMAKE_INSTALL_INCLUDEDIR=${vulkan-headers}/include" ]
    ++ lib.optional stdenv.isDarwin "-DSYSCONFDIR=${moltenvk}/share"
    ++ lib.optional stdenv.isLinux "-DSYSCONFDIR=${addDriverRunpath.driverLink}/share"
    ++ lib.optional (stdenv.buildPlatform != stdenv.hostPlatform) "-DUSE_GAS=OFF";

  outputs = [ "out" "dev" ];

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
    homepage    = "https://www.lunarg.com";
    platforms   = platforms.unix ++ platforms.windows;
    license     = licenses.asl20;
    maintainers = [ maintainers.ralith ];
    broken = finalAttrs.version != vulkan-headers.version;
    pkgConfigModules = [ "vulkan" ];
  };
})
