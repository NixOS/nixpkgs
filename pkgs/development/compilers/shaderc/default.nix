{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
  autoSignDarwinBinariesHook,
  cctools,
}:
# Like many google projects, shaderc doesn't gracefully support separately
# compiled dependencies, so we can't easily use the versions of glslang and
# spirv-tools used by vulkan-loader. Exact revisions are taken from
# https://github.com/google/shaderc/blob/known-good/known_good.json

# Future work: extract and fetch all revisions automatically based on a revision
# of shaderc's known-good branch.
let
  glslang = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "glslang";
    rev = "15.3.0";
    hash = "sha256-HwFP4KJuA+BMQVvBWV0BCRj9U5I3CLEU+5bBtde2f6w=";
  };
  spirv-tools = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Tools";
    rev = "v2025.1";
    hash = "sha256-2Wv0dxVQ8NvuDRTcsXkH1GKmuA6lsIuwTl0j6kbTefo=";
  };
  spirv-headers = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "vulkan-sdk-1.4.309.0";
    hash = "sha256-Q1i6i5XimULuGufP6mimwDW674anAETUiIEvDQwvg5Y=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "shaderc";
  version = "2025.2";

  outputs = [
    "out"
    "lib"
    "bin"
    "dev"
    "static"
  ];

  src = fetchFromGitHub {
    owner = "google";
    repo = "shaderc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-u3gmH2lrkwBTZg9j4jInQceXK4MUWhKZPSPsN98mEkk=";
  };

  postPatch = ''
    cp -r --no-preserve=mode ${glslang} third_party/glslang
    cp -r --no-preserve=mode ${spirv-tools} third_party/spirv-tools
    ln -s ${spirv-headers} third_party/spirv-tools/external/spirv-headers
    patchShebangs --build utils/
  '';

  nativeBuildInputs =
    [
      cmake
      python3
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ cctools ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
      autoSignDarwinBinariesHook
    ];

  postInstall = ''
    moveToOutput "lib/*.a" $static
  '';

  cmakeFlags = [ "-DSHADERC_SKIP_TESTS=ON" ];

  # Fix the paths in .pc, even though it's unclear if all these .pc are really useful.
  postFixup = ''
    substituteInPlace "$dev"/lib/pkgconfig/*.pc \
      --replace-fail '=''${prefix}//' '=/' \
      --replace-fail "$dev/$dev/" "$dev/"
  '';

  meta = {
    description = "Collection of tools, libraries and tests for shader compilation";
    inherit (finalAttrs.src.meta) homepage;
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
})
