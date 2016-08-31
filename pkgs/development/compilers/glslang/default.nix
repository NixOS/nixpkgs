{ stdenv, fetchFromGitHub, cmake, bison }:

stdenv.mkDerivation rec {
  name = "glslang-${version}";
  version = "2016-07-16";

  # `vulkan-loader` requires a specific version of `glslang` as specified in
  # `<vulkan-loader-repo>/glslang_revision`.
  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "glslang";
    rev = "e4821e43c86d97bcf65fb07c1f70471b7102978d";
    sha256 = "0vnfl8r5ssil1sffgk9sf7c7n5l3775pfizxgb1bcyvm84vw0pr3";
  };

  patches = [ ./install-headers.patch ];

  buildInputs = [ cmake bison ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Khronos reference front-end for GLSL and ESSL";
  };
}
