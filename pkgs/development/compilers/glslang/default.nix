{ stdenv, fetchFromGitHub, cmake, bison }:

stdenv.mkDerivation rec {
  name = "glslang-git-${version}";
  version = "2016-08-26";

  # `vulkan-loader` requires a specific version of `glslang` as specified in
  # `<vulkan-loader-repo>/glslang_revision`.
  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "glslang";
    rev = "81cd764b5ffc475bc73f1fb35f75fd1171bb2343";
    sha256 = "1vfwl6lzkjh9nh29q32b7zca4q1abf3q4nqkahskijgznw5lr59g";
  };

  patches = [ ./install-headers.patch ];

  buildInputs = [ cmake bison ];
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Khronos reference front-end for GLSL and ESSL";
  };
}
