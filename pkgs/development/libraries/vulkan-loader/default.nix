{ stdenv, fetchFromGitHub, cmake, python3, vulkan-headers, pkgconfig
, xlibsWrapper, libxcb, libXrandr, libXext, wayland, libGL_driver }:

let
  version = "1.1.106";
in

assert version == vulkan-headers.version;
stdenv.mkDerivation rec {
  name = "vulkan-loader-${version}";
  inherit version;

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Loader";
    rev = "sdk-${version}";
    sha256 = "0zhrwj1gi90x2w8gaaaw5h4b969a8gfy244kn0drrplhhb1nqz3b";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake python3 xlibsWrapper libxcb libXrandr libXext wayland ];
  enableParallelBuilding = true;

  cmakeFlags = [
    "-DFALLBACK_DATA_DIRS=${libGL_driver.driverLink}/share:/usr/local/share:/usr/share"
    "-DVULKAN_HEADERS_INSTALL_DIR=${vulkan-headers}"
  ];

  outputs = [ "out" "dev" ];

  meta = with stdenv.lib; {
    description = "LunarG Vulkan loader";
    homepage    = https://www.lunarg.com;
    platforms   = platforms.linux;
    license     = licenses.asl20;
    maintainers = [ maintainers.ralith ];
  };
}
