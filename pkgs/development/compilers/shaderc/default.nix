{ stdenv, fetchFromGitHub, cmake, python3 }:
# Like many google projects, shaderc doesn't gracefully support separately compiled dependencies, so we can't easily use
# the versions of glslang and spirv-tools used by vulkan-loader. Exact revisions are taken from
# https://github.com/google/shaderc/blob/known-good/known_good.json

# Future work: extract and fetch all revisions automatically based on a revision of shaderc's known-good branch.
let
  glslang = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "glslang";
    rev = "3ee5f2f1d3316e228916788b300d786bb574d337";
    sha256 = "1l5h9d92mzd35pgs0wibqfg7vbl771lwnvdlcsyhf6999khn5dzv";
  };
  spirv-tools = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Tools";
    rev = "b63f0e5ed3e818870968ebf6af73317127fd07b0";
    sha256 = "1chv30azfp76nha428ivg4ixrij6d8pxj5kn3jam87gmkmgc9zhm";
  };
  spirv-headers = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "979924c8bc839e4cb1b69d03d48398551f369ce7";
    sha256 = "07vyjlblpm4zhfds612h86lnz0qvrj5qqw5z2zzfa3m9fax7cm85";
  };
in stdenv.mkDerivation rec {
  pname = "shaderc";
  version = "2020.2";

  outputs = [ "out" "lib" "bin" "dev" "static" ];

  src = fetchFromGitHub {
    owner = "google";
    repo = "shaderc";
    rev = "v${version}";
    sha256 = "1sxz8872x3rdlrhmbn83r1vniq4j51jnk0ka3447fq68il4myf1w";
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
    description = "A collection of tools, libraries and tests for shader compilation";
    license = [ licenses.asl20 ];
  };
}
