{ lib, stdenv, fetchFromGitHub, cmake, python3, vulkan-headers, pkg-config
, xlibsWrapper, libxcb, libXrandr, libXext, wayland, addOpenGLRunpath }:

stdenv.mkDerivation rec {
  pname = "vulkan-loader";
  version = "1.2.162.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Loader";
    rev = "sdk-${version}";
    sha256 = "0w9i2pliw4ccmjyfzff4i2f3hxwsfd54jg7ahv2v634qmx59bsbi";
  };

  nativeBuildInputs = [ pkg-config cmake ];
  buildInputs = [ python3 xlibsWrapper libxcb libXrandr libXext wayland ];

  cmakeFlags = [
    "-DSYSCONFDIR=${addOpenGLRunpath.driverLink}/share"
    "-DVULKAN_HEADERS_INSTALL_DIR=${vulkan-headers}"
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
