{ stdenv, fetchFromGitHub, cmake, bison }:

stdenv.mkDerivation rec {
  name = "glslang-git-${version}";
  version = "2017-08-31";

  # `vulkan-loader` requires a specific version of `glslang` as specified in
  # `<vulkan-loader-repo>/external_revisions/glslang_revision`.
  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "glslang";
    rev = "3a21c880500eac21cdf79bef5b80f970a55ac6af";
    sha256 = "1i15m17r0acmzjrkybris2rgw15il05a4w5h7vhhsiyngcvajcyn";
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
