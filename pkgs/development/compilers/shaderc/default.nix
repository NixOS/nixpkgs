{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
  autoSignDarwinBinariesHook,
  cctools,
}:
# Like many google projects, shaderc doesn't gracefully support separately compiled dependencies, so we can't easily use
# the versions of glslang and spirv-tools used by vulkan-loader. Exact revisions are taken from
# https://github.com/google/shaderc/blob/known-good/known_good.json

# Future work: extract and fetch all revisions automatically based on a revision of shaderc's known-good branch.
let
  glslang = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "glslang";
    rev = "6be56e45e574b375d759b89dad35f780bbd4792f";
    hash = "sha256-tktdsj4sxwQHBavHzu1x8H28RrIqSQs/fp2TQcVCm2g=";
  };
  spirv-tools = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Tools";
    rev = "360d469b9eac54d6c6e20f609f9ec35e3a5380ad";
    hash = "sha256-Bned5Pa6zCFByfNvqD0M5t3l4uAJYkDlpe6wu8e7a3U=";
  };
  spirv-headers = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "4183b260f4cccae52a89efdfcdd43c4897989f42";
    hash = "sha256-RKjw3H1z02bl6730xsbo38yjMaOCsHZP9xJOQbmWpnw=";
  };
in
stdenv.mkDerivation rec {
  pname = "shaderc";
  version = "2024.0";

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
    rev = "v${version}";
    hash = "sha256-Cwp7WbaKWw/wL9m70wfYu47xoUGQW+QGeoYhbyyzstQ=";
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
