{ stdenv, fetchFromGitHub, cmake, python3, vulkan-headers, pkgconfig
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

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ python3 xlibsWrapper libxcb libXrandr libXext wayland ];

  preConfigure = ''
    substituteInPlace loader/vulkan.pc.in \
      --replace 'includedir=''${prefix}/include' 'includedir=${vulkan-headers}/include' \
      --replace 'libdir=''${exec_prefix}/@CMAKE_INSTALL_LIBDIR@' 'libdir=@CMAKE_INSTALL_LIBDIR@'
  '';

  cmakeFlags = [
    "-DSYSCONFDIR=${addOpenGLRunpath.driverLink}/share"
    "-DVULKAN_HEADERS_INSTALL_DIR=${vulkan-headers}"
  ];

  outputs = [ "out" "dev" ];

  meta = with stdenv.lib; {
    description = "LunarG Vulkan loader";
    homepage    = "https://www.lunarg.com";
    platforms   = platforms.linux;
    license     = licenses.asl20;
    maintainers = [ maintainers.ralith ];
  };
}
