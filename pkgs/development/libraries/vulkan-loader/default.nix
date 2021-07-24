{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, libX11, libxcb
, libXrandr, wayland, vulkan-headers, addOpenGLRunpath }:

stdenv.mkDerivation rec {
  pname = "vulkan-loader";
  version = "1.2.182.0";

  src = (assert version == vulkan-headers.version;
    fetchFromGitHub {
      owner = "KhronosGroup";
      repo = "Vulkan-Loader";
      rev = "sdk-${version}";
      sha256 = "0gmr9q3a6s8xvaa74fs9zbi9c305i2b3rx768qvl79nhbdj8nc02";
    });

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ libX11 libxcb libXrandr vulkan-headers wayland ];

  cmakeFlags = [
    "-DSYSCONFDIR=${addOpenGLRunpath.driverLink}/share"
    "-DCMAKE_INSTALL_INCLUDEDIR=${vulkan-headers}/include"
  ];

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
    platforms   = platforms.linux;
    license     = licenses.asl20;
    maintainers = [ maintainers.ralith ];
  };
}
