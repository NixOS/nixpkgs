{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, libX11, libxcb
, libXrandr, wayland, moltenvk, vulkan-headers, addOpenGLRunpath }:

stdenv.mkDerivation rec {
  pname = "vulkan-loader";
  version = "1.3.231.0";

  src = (assert version == vulkan-headers.version;
    fetchFromGitHub {
      owner = "KhronosGroup";
      repo = "Vulkan-Loader";
      rev = "sdk-${version}";
      hash = "sha256-HWaa3JT0znhvqbvZdcsAwy8Dr6HDQp4rgpVmMOuCo0s=";
    });

  patches = [ ./fix-pkgconfig.patch ];

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ vulkan-headers ]
    ++ lib.optionals (!stdenv.isDarwin) [ libX11 libxcb libXrandr wayland ];

  cmakeFlags = [ "-DCMAKE_INSTALL_INCLUDEDIR=${vulkan-headers}/include" ]
    ++ lib.optional stdenv.isDarwin "-DSYSCONFDIR=${moltenvk}/share"
    ++ lib.optional stdenv.isLinux "-DSYSCONFDIR=${addOpenGLRunpath.driverLink}/share"
    ++ lib.optional (stdenv.buildPlatform != stdenv.hostPlatform) "-DUSE_GAS=OFF";

  outputs = [ "out" "dev" ];

  doInstallCheck = true;

  installCheckPhase = ''
    grep -q "${vulkan-headers}/include" $dev/lib/pkgconfig/vulkan.pc || {
      echo vulkan-headers include directory not found in pkg-config file
      exit 1
    }
  '';

  meta = with lib; {
    description = "LunarG Vulkan loader";
    homepage    = "https://www.lunarg.com";
    platforms   = platforms.unix;
    license     = licenses.asl20;
    maintainers = [ maintainers.ralith ];
  };
}
