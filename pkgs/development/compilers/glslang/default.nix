{ stdenv, fetchFromGitHub, cmake, bison }:

stdenv.mkDerivation rec {
  name = "glslang-git-${version}";
  version = "2016-12-21";

  # `vulkan-loader` requires a specific version of `glslang` as specified in
  # `<vulkan-loader-repo>/glslang_revision`.
  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "glslang";
    rev = "807a0d9e2f4e176f75d62ac3c179c81800ec2608";
    sha256 = "02jckgihqhagm73glipb4c6ri5fr3pnbxb5vrznn2vppyfdfghbj";
  };

  patches = [ ./install-headers.patch ];

  buildInputs = [ cmake bison ];
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Khronos reference front-end for GLSL and ESSL";
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
