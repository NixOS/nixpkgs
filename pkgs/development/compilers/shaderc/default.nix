{ stdenv, fetchFromGitHub, cmake, python3 }:
# Like many google projects, shaderc doesn't gracefully support separately compiled dependencies, so we can't easily use
# the versions of glslang and spirv-tools used by vulkan-loader. Exact revisions are taken from
# https://github.com/google/shaderc/blob/known-good/known_good.json

# Future work: extract and fetch all revisions automatically based on a revision of shaderc's known-good branch.
let
  glslang = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "glslang";
    rev = "d3692c701b1265955221aa0d6ebc656bc4442b2a";
    sha256 = "11cvwbzlpr4zrcmmyd9h0kbfhmhr6r696ydmn0yp1jrixby4bmji";
  };
  spirv-tools = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Tools";
    rev = "08cc49ec59c3ff4d6bd4bb4f2097ede35e802158";
    sha256 = "1xhgcppx02fp3nr7654mr3qrgy1fxlxdyl87jhmn3k9jf24gmmmz";
  };
  spirv-headers = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "8b911bd2ba37677037b38c9bd286c7c05701bcda";
    sha256 = "0qdnj34bkagszyvci6ifpqd7iqvybhmqzvc9lvqnls44qg90aqh2";
  };
in stdenv.mkDerivation rec {
  pname = "shaderc";
  version = "2019.0";

  outputs = [ "out" "lib" "bin" "dev" "static" ];

  src = fetchFromGitHub {
    owner = "google";
    repo = "shaderc";
    rev = "v${version}";
    sha256 = "1l5mmyxhzsbp0a6y2d86i8jmf46c6bjgjkdgkr5l8hmhflmm7gi2";
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
