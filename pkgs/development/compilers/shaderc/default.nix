{ lib, stdenv, fetchFromGitHub, cmake, python3, autoSignDarwinBinariesHook, cctools }:
# Like many google projects, shaderc doesn't gracefully support separately compiled dependencies, so we can't easily use
# the versions of glslang and spirv-tools used by vulkan-loader. Exact revisions are taken from
# https://github.com/google/shaderc/blob/known-good/known_good.json

# Future work: extract and fetch all revisions automatically based on a revision of shaderc's known-good branch.
let
  glslang = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "glslang";
    rev = "728c689574fba7e53305b475cd57f196c1a21226";
    hash = "sha256-BAgDQosiO3e4yy2DpQ6SjrJNrHTUDSduHFRvzWvd4v0=";
  };
  spirv-tools = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Tools";
    rev = "d9446130d5165f7fafcb3599252a22e264c7d4bd";
    hash = "sha256-fuYhzfkWXDm1icLHifc32XZCNQ6Dj5f5WJslT2JoMbc=";
  };
  spirv-headers = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "c214f6f2d1a7253bb0e9f195c2dc5b0659dc99ef";
    hash = "sha256-/9EDOiqN6ZzDhRKP/Kv8D/BT2Cs7G8wyzEsGATLpmrA=";
  };
in
stdenv.mkDerivation rec {
  pname = "shaderc";
  version = "2022.4";

  outputs = [ "out" "lib" "bin" "dev" "static" ];

  src = fetchFromGitHub {
    owner = "google";
    repo = "shaderc";
    rev = "v${version}";
    hash = "sha256-/p2gJ7Lnh8IfvwBwHPDtmfLJ8j+Rbv+Oxu9lxY6fxfk=";
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
