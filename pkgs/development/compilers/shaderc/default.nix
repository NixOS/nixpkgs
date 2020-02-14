{ stdenv, fetchFromGitHub, cmake, python3 }:
# Like many google projects, shaderc doesn't gracefully support separately compiled dependencies, so we can't easily use
# the versions of glslang and spirv-tools used by vulkan-loader. Exact revisions are taken from
# https://github.com/google/shaderc/blob/known-good/known_good.json

# Future work: extract and fetch all revisions automatically based on a revision of shaderc's known-good branch.
let
  glslang = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "glslang";
    rev = "3ed344dd784ecbbc5855e613786f3a1238823e56";
    sha256 = "00s2arfvw78d9k9fmangqlkvkmkpqzrin3g91vfab4wr8srb09dx";
  };
  spirv-tools = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Tools";
    rev = "323a81fc5e30e43a04e5e22af4cba98ca2a161e6";
    sha256 = "1kwyh95l02w3v1ra55c836wayzw8d0m14ab7wf0ynhhyp3k2p9hv";
  };
  spirv-headers = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "204cd131c42b90d129073719f2766293ce35c081";
    sha256 = "1gp0mlbfccqnalaix97jxsa5i337xyzyr55wgssapy56p0q04wv2";
  };
in stdenv.mkDerivation rec {
  pname = "shaderc";
  version = "2019.1";

  outputs = [ "out" "lib" "bin" "dev" "static" ];

  src = fetchFromGitHub {
    owner = "google";
    repo = "shaderc";
    rev = "v${version}";
    sha256 = "0x514rpignnb4vvl7wmijfakqc59986knjw3dh1zx0ah42xa7x37";
  };

  patchPhase = ''
    cp -r --no-preserve=mode ${glslang} third_party/glslang
    cp -r --no-preserve=mode ${spirv-tools} third_party/spirv-tools
    ln -s ${spirv-headers} third_party/spirv-tools/external/spirv-headers
  '';

  nativeBuildInputs = [ cmake python3 ];

  postInstall = ''
    moveToOutput "lib/*.a" $static
  '';

  cmakeFlags = [ "-DSHADERC_SKIP_TESTS=ON" ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "A collection of tools, libraries and tests for shader compilation.";
    license = [ licenses.asl20 ];
  };
}
