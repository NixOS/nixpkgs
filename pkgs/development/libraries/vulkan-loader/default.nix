{ stdenv, fetchgit, fetchFromGitHub, cmake, pkgconfig, git, python3,
  python3Packages, glslang, spirv-tools, x11, libxcb, wayland }:

assert stdenv.system == "x86_64-linux";

stdenv.mkDerivation rec {
  name = "vulkan-loader-${version}";
  version = "1.0.21.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-LoaderAndValidationLayers";
    rev = "97e3b677d9681aa8d420c314edae96c4bf72246d";
    sha256 = "1y42rlffmr80rd4m0xfv2mfwd9qvd680i18vr0xs109narb6fm4f";
  };

  buildInputs = [ cmake pkgconfig git python3 python3Packages.lxml
                  glslang spirv-tools x11 libxcb wayland
                ];

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
