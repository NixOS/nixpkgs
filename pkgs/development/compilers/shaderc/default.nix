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
# the DEPS file in the shaderc repository.
let
  # dependency revs taken from here:
  # From https://github.com/google/shaderc/blob/v2025.2/DEPS:
  glslang = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "glslang";
    rev = "697683e6b8871420d7d942b1a2fe233242ab5608";
    hash = "sha256-+iX5TOPFwAWrzRKd4gikzYIWfzSdmRCukY6WsKNJCzE=";
  };
  spirv-tools = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Tools";
    rev = "a62abcb402009b9ca5975e6167c09f237f630e0e";
    hash = "sha256-nGyEOREua/W2mdb8DhmqXW0gDThnXnIlhnURAUhCO2g=";
  };
  spirv-headers = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "aa6cef192b8e693916eb713e7a9ccadf06062ceb";
    hash = "sha256-bUgt7m3vJYoozxgrA5hVTRcbPg3OAzht0e+MgTH7q9k=";
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
