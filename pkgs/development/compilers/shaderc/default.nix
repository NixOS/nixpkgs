{ stdenv, fetchFromGitHub, cmake, glslang, spirv-tools, python }:

stdenv.mkDerivation rec {
  name = "shaderc-git-${version}";
  version = "2016-09-08";

  # `vulkan-loader` requires a specific version of `glslang` as specified in
  # `<vulkan-loader-repo>/glslang_revision`.
  src = fetchFromGitHub {
    owner = "google";
    repo = "shaderc";
    rev = "e17bb8ba3b8b0b9142b788d988612a40541c54ce";
    sha256 = "17qfjqkz6j355qi130kixaz51svl09k9b5sfikksgnbmzglzcwki";
  };

  patchPhase = ''
    cp -r ${spirv-tools.src} third_party/spirv-tools
    chmod -R +w third_party/spirv-tools
    ln -s ${spirv-tools.headers} third_party/spirv-tools/external/spirv-headers
  '';

  buildInputs = [ cmake glslang python ];
  enableParallelBuilding = true;

  cmakeFlags = [ "-DSHADERC_SKIP_TESTS=ON" "-DSHADERC_GLSLANG_DIR=${glslang.src}" ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "A collection of tools, libraries and tests for shader compilation.";
  };
}
