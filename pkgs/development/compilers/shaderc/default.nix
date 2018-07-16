{ stdenv, fetchFromGitHub, cmake, python }:
# Like many google projects, shaderc doesn't gracefully support separately compiled dependencies, so we can't easily use
# the versions of glslang and spirv-tools used by vulkan-loader. Exact revisions are taken from
# https://github.com/google/shaderc/blob/known-good/known_good.json

# Future work: extract and fetch all revisions automatically based on a revision of shaderc's known-good branch.
let
  glslang = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "glslang";
    rev = "32d3ec319909fcad0b2b308fe1635198773e8316";
    sha256 = "1kmgjv5kbrjy6azpgwnjcn3cj8vg5i8hnyk3m969sc0gq2j1rbjj";
  };
  spirv-tools = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Tools";
    rev = "fe2fbee294a8ad4434f828a8b4d99eafe9aac88c";
    sha256 = "03rq4ypwqnz34n8ip85n95a3b9rxb34j26azzm3b3invaqchv19x";
  };
  spirv-headers = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "3ce3e49d73b8abbf2ffe33f829f941fb2a40f552";
    sha256 = "0yk4bzqifdqpmdxkhvrxbdqhf5ngkga0ig1yyz7khr7rklqfz7wp";
  };
in stdenv.mkDerivation rec {
  name = "shaderc-git-${version}";
  version = "2018-06-01";

  src = fetchFromGitHub {
    owner = "google";
    repo = "shaderc";
    rev = "be8e0879750303a1de09385465d6b20ecb8b380d";
    sha256 = "16p25ry2i4zrj00zihfpf210f8xd7g398ffbw25igvi9mbn4nbfd";
  };

  patchPhase = ''
    cp -r --no-preserve=mode ${glslang} third_party/glslang
    cp -r --no-preserve=mode ${spirv-tools} third_party/spirv-tools
    ln -s ${spirv-headers} third_party/spirv-tools/external/spirv-headers
  '';

  buildInputs = [ cmake python ];
  enableParallelBuilding = true;

  cmakeFlags = [ "-DSHADERC_SKIP_TESTS=ON" ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "A collection of tools, libraries and tests for shader compilation.";
  };
}
