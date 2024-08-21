{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, libX11, libxcb
, libXrandr, wayland, moltenvk, vulkan-headers, addDriverRunpath
, testers }:

stdenv.mkDerivation (finalAttrs: {
  pname = "vulkan-loader";
  version = "1.3.283.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Loader";
    rev = "vulkan-sdk-${finalAttrs.version}";
    hash = "sha256-pe4WYbfB20yRI5Pg+RxgmQcmdXsSoRxbBkQ3DdAL8r4=";
  };

  patches = [ ./fix-pkgconfig.patch ];

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
