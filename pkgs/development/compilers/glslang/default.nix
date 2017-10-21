{ stdenv, fetchFromGitHub, cmake, bison }:

stdenv.mkDerivation rec {
  name = "glslang-git-${version}";
  version = "2017-03-29";

  # `vulkan-loader` requires a specific version of `glslang` as specified in
  # `<vulkan-loader-repo>/external_revisions/glslang_revision`.
  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "glslang";
    rev = "714e58b2fc5a45714596e6aa2f6ac8f64260365c";
    sha256 = "0ihnd0c4mr6ppbv9g7z1abrn8vx66simfzx5q48nqcpnywn35jxv";
  };

  buildInputs = [ cmake bison ];
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Khronos reference front-end for GLSL and ESSL";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.ralith ];
  };
}
