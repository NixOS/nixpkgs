{ lib, stdenv, fetchFromGitHub, cmake, python3, autoSignDarwinBinariesHook, cctools }:
# Like many google projects, shaderc doesn't gracefully support separately compiled dependencies, so we can't easily use
# the versions of glslang and spirv-tools used by vulkan-loader. Exact revisions are taken from
# https://github.com/google/shaderc/blob/known-good/known_good.json

# Future work: extract and fetch all revisions automatically based on a revision of shaderc's known-good branch.
let
  glslang = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "glslang";
    rev = "18eef33bd7a4bf5ad8c69f99cb72022608cf6e73";
    sha256 = "sha256-tkWVvYmSpJPaZ8VJOkAWndDWhA0PiHAkR3feBAo+knM=";
  };
  spirv-tools = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Tools";
    rev = "c2d5375fa7cc87c93f692e7200d5d974283d4391";
    sha256 = "sha256-tMJRljrlH+qb+27rTn+3LuEyMOVpiU0zSCiGNfUTb6g=";
  };
  spirv-headers = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "0c28b6451d77774912e52949c1e57fa726edf113";
    sha256 = "sha256-KpCMceTV/BRaoJe1qeXhKYQNQqdGaM6Q9nklpJKzHFY=";
  };
in
stdenv.mkDerivation rec {
  pname = "shaderc";
  version = "2021.0";

  outputs = [ "out" "lib" "bin" "dev" "static" ];

  src = fetchFromGitHub {
    owner = "google";
    repo = "shaderc";
    rev = "v${version}";
    sha256 = "sha256-RfSMzrGVtdXbr/mjSrHoN447e3vMQfJbesQMvLOARBs=";
  };

  patchPhase = ''
    cp -r --no-preserve=mode ${glslang} third_party/glslang
    cp -r --no-preserve=mode ${spirv-tools} third_party/spirv-tools
    ln -s ${spirv-headers} third_party/spirv-tools/external/spirv-headers
  '';

  nativeBuildInputs = [ cmake python3 ]
    ++ lib.optionals stdenv.isDarwin [ cctools ]
    ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [ autoSignDarwinBinariesHook ];

  postInstall = ''
    moveToOutput "lib/*.a" $static
  '';

  cmakeFlags = [ "-DSHADERC_SKIP_TESTS=ON" ];

  # Fix the paths in .pc, even though it's unclear if all these .pc are really useful.
  postFixup = ''
    substituteInPlace "$dev"/lib/pkgconfig/*.pc \
      --replace '=''${prefix}//' '=/' \
      --replace "$dev/$dev/" "$dev/"
  '';

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "A collection of tools, libraries and tests for shader compilation";
    platforms = platforms.all;
    license = [ licenses.asl20 ];
  };
}
