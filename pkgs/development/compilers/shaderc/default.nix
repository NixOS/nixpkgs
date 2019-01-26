{ stdenv, fetchFromGitHub, cmake, python }:
# Like many google projects, shaderc doesn't gracefully support separately compiled dependencies, so we can't easily use
# the versions of glslang and spirv-tools used by vulkan-loader. Exact revisions are taken from
# https://github.com/google/shaderc/blob/known-good/known_good.json

# Future work: extract and fetch all revisions automatically based on a revision of shaderc's known-good branch.
let
  glslang = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "glslang";
    rev = "712cd6618df2c77e126d68042ad7a81a69ee4a6f";
    sha256 = "0wncdj6q1hn40lc7cnz97mx5qjvb8p13mhxilnncgcmf0crsvblz";
  };
  spirv-tools = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Tools";
    rev = "df5bd2d05ac1fd3ec3024439f885ec21cc949b22";
    sha256 = "0l8ds4nn2qcfi8535ai8891i3547x35hscs2jxwwq6qjgw1sgkax";
  };
  spirv-headers = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "79b6681aadcb53c27d1052e5f8a0e82a981dbf2f";
    sha256 = "0flng2rdmc4ndq3j71h6wk1ibcjvhjrg2rzd6rv445vcsf0jh2pj";
  };
in stdenv.mkDerivation rec {
  name = "shaderc-${version}";
  version = "2018.0";

  outputs = [ "out" "lib" "bin" "dev" "static" ];

  src = fetchFromGitHub {
    owner = "google";
    repo = "shaderc";
    rev = "v${version}";
    sha256 = "0qigmj0riw43pgjn5f6kpvk72fajssz1lc2aiqib5qvmj9rqq3hl";
  };

  patchPhase = ''
    cp -r --no-preserve=mode ${glslang} third_party/glslang
    cp -r --no-preserve=mode ${spirv-tools} third_party/spirv-tools
    ln -s ${spirv-headers} third_party/spirv-tools/external/spirv-headers
  '';

  nativeBuildInputs = [ cmake python ];

  postInstall = ''
    moveToOutput "lib/*.a" $static
  '';

  preConfigure = ''cmakeFlags="$cmakeFlags -DCMAKE_INSTALL_BINDIR=$bin/bin"'';

  enableParallelBuilding = true;

  cmakeFlags = [ "-DSHADERC_SKIP_TESTS=ON" ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "A collection of tools, libraries and tests for shader compilation.";
    license = [ licenses.asl20 ];
  };
}
