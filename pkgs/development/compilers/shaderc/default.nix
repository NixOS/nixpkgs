{ stdenv, fetchFromGitHub, cmake, python3 }:
# Like many google projects, shaderc doesn't gracefully support separately compiled dependencies, so we can't easily use
# the versions of glslang and spirv-tools used by vulkan-loader. Exact revisions are taken from
# https://github.com/google/shaderc/blob/known-good/known_good.json

# Future work: extract and fetch all revisions automatically based on a revision of shaderc's known-good branch.
let
  glslang = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "glslang";
    rev = "d39b8afc47a1f700b5670463c0d1068878acee6f";
    sha256 = "1w6drs4mzlll5sp0i4zikfxsjxqjvl3xzphy5gd4s808ngwyrs7i";
  };
  spirv-tools = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Tools";
    rev = "e128ab0d624ce7beb08eb9656bb260c597a46d0a";
    sha256 = "0jj8zrl3dh9fq71jc8msx3f3ifb2vjcb37nl0w4sa8sdhfff74pv";
  };
  spirv-headers = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "ac638f1815425403e946d0ab78bac71d2bdbf3be";
    sha256 = "1lkhs7pxcrfkmiizcxl0w5ajx6swwjv7w3iq586ipgh571fc75gx";
  };
in stdenv.mkDerivation rec {
  pname = "shaderc";
  version = "2020.1";

  outputs = [ "out" "lib" "bin" "dev" "static" ];

  src = fetchFromGitHub {
    owner = "google";
    repo = "shaderc";
    rev = "v${version}";
    sha256 = "000sgg6w59yrd84yvdzckqm9ycdqp1knn0agxyixazcn9rs1lgjj";
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
