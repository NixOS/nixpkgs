{ stdenv, fetchgit, fetchFromGitHub, cmake, git, python3, libxcb
, python3Packages, glslang, pkgconfig, x11 }:

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

  buildInputs = [ cmake git python3 libxcb python3Packages.lxml glslang
                  pkgconfig x11
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
