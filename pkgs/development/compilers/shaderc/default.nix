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
  # this is the git tag of the google/shaderc repo
  version = "2025.2";

  src = fetchFromGitHub {
    owner = "google";
    repo = "shaderc";
    rev = "v${version}";
    hash = "sha256-u3gmH2lrkwBTZg9j4jInQceXK4MUWhKZPSPsN98mEkk=";
  };

  # Read the DEPS file
  depsContent = builtins.readFile "${src}/DEPS";

  # Function to extract a specific revision hash from DEPS file
  getDepsRevision =
    revisionKey:
    let
      lines = lib.splitString "\n" depsContent;
      # Find the line containing the revision key
      revisionLine = lib.findFirst (line: builtins.match ".*'${revisionKey}'.*" line != null) null lines;

      # find the commit hash inside the DEPS file
      match = builtins.match ".*'${revisionKey}':[[:space:]]*'([^']+)'.*" revisionLine;

      revstring = builtins.elemAt match 0;
    in
    revstring;

  glslang = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "glslang";
    rev = getDepsRevision "glslang_revision";
    hash = "sha256-+iX5TOPFwAWrzRKd4gikzYIWfzSdmRCukY6WsKNJCzE=";
  };
  spirv-tools = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Tools";
    rev = getDepsRevision "spirv_tools_revision";
    hash = "sha256-nGyEOREua/W2mdb8DhmqXW0gDThnXnIlhnURAUhCO2g=";
  };
  spirv-headers = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = getDepsRevision "spirv_headers_revision";
    hash = "sha256-bUgt7m3vJYoozxgrA5hVTRcbPg3OAzht0e+MgTH7q9k=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "shaderc";
  inherit version src;

  outputs = [
    "out"
    "lib"
    "bin"
    "dev"
    "static"
  ];

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
