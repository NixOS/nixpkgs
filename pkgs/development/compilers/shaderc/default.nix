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
    # No corresponding tag for efd24d75bcbc55620e759f6bf42c45a32abac5f8 on 2025-06-23
    rev = "efd24d75bcbc55620e759f6bf42c45a32abac5f8";
    hash = "sha256-wMd1ylwDOM/uBbhpyMAduM9X7ao08TNq3HdoNGfSjcQ=";
  };
  spirv-tools = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Tools";
    rev = "v2025.3.rc1";
    hash = "sha256-yAdd/mXY8EJnE0vCu0n/aVxMH9059T/7cAdB9nP1vQQ=";
  };
  spirv-headers = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    # No corresponding tag for 2a611a970fdbc41ac2e3e328802aed9985352dca on 2025-06-19
    rev = "2a611a970fdbc41ac2e3e328802aed9985352dca";
    hash = "sha256-LRjMy9xtOErbJbMh+g2IKXfmo/hWpegZM72F8E122oY=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "shaderc";
  version = "2025.3";

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
    hash = "sha256-q5Z0wER8DbkmfT/MNrmnn9J9rzur2YjzAncaO1aRNXA=";
  };

  postPatch = ''
    cp -r --no-preserve=mode ${glslang} third_party/glslang
    cp -r --no-preserve=mode ${spirv-tools} third_party/spirv-tools
    ln -s ${spirv-headers} third_party/spirv-tools/external/spirv-headers
    patchShebangs --build utils/
  '';

  nativeBuildInputs = [
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
