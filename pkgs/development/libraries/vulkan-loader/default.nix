{ stdenv, fetchFromGitHub, cmake, python3, vulkan-headers, pkgconfig
, xlibsWrapper, libxcb, libXrandr, libXext, wayland, libGL_driver }:

let
  version = "1.1.85";
in

assert version == vulkan-headers.version;
stdenv.mkDerivation rec {
  name = "vulkan-loader-${version}";
  inherit version;

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Loader";
    rev = "b02f64293680c484e1d7ff6ecb88f89277c0dc8c";
    sha256 = "1n4vjyxlmi2ygx34srwbvalc5gz95gcsrmdw0k10353xja755gmj";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake python3 xlibsWrapper libxcb libXrandr libXext wayland ];
  enableParallelBuilding = true;

  cmakeFlags = [
    "-DFALLBACK_DATA_DIRS=${libGL_driver.driverLink}/share:/usr/local/share:/usr/share"
    "-DVULKAN_HEADERS_INSTALL_DIR=${vulkan-headers}"
  ];

  outputs = [ "out" "dev" ];

  postInstall = ''
    cp -r "${vulkan-headers}/include" "$dev"
  '';

  meta = with stdenv.lib; {
    description = "LunarG Vulkan loader";
    homepage    = https://www.lunarg.com;
    platforms   = platforms.linux;
    license     = licenses.asl20;
    maintainers = [ maintainers.ralith ];
  };
}
