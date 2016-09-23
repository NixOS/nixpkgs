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
  getRev = name: builtins.substring 0 40 (builtins.readFile "${src}/${name}_revision");
in

assert getRev "spirv-tools" == spirv-tools.src.rev;
assert getRev "spirv-headers" == spirv-tools.headers.rev;
assert getRev "glslang" == glslang.src.rev;

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
