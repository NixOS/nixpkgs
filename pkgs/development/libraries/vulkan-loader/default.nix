{ stdenv, fetchgit, fetchFromGitHub, cmake, pkgconfig, git, python3,
  python3Packages, glslang, spirv-tools, x11, libxcb, wayland }:

assert stdenv.system == "x86_64-linux";

let
  version = "1.0.26.0";
  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-LoaderAndValidationLayers";
    rev = "sdk-${version}";
    sha256 = "157m746hc76xrxd3qq0f44f5dy7pjbz8cx74ykqrlbc7rmpjpk58";
  };
in

stdenv.mkDerivation rec {
  name = "vulkan-loader-${version}";
  inherit version src;

  buildInputs = [ cmake pkgconfig git python3 python3Packages.lxml
                  glslang spirv-tools x11 libxcb wayland
                ];
  enableParallelBuilding = true;

  cmakeFlags = [
    "-DBUILD_WSI_WAYLAND_SUPPORT=ON" # XLIB/XCB supported by default
  ];

  preConfigure = ''
    checkRev() {
      [ "$2" = $(cat "$1_revision") ] || (echo "ERROR: dependency $1 is revision $2 but should be revision" $(cat "$1_revision") && exit 1)
    }
    checkRev spirv-tools "${spirv-tools.src.rev}"
    checkRev spirv-headers "${spirv-tools.headers.rev}"
    checkRev glslang "${glslang.src.rev}"
  '';

  installPhase = ''
    mkdir -p $out/lib
    mkdir -p $out/bin
    cp loader/libvulkan.so* $out/lib
    cp demos/vulkaninfo $out/bin
  '';

  meta = with stdenv.lib; {
    description = "LunarG Vulkan loader";
    homepage    = http://www.lunarg.com;
    platforms   = platforms.linux;
  };
}
