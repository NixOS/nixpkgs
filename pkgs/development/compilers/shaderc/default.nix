{ lib, stdenv, fetchFromGitHub, cmake, python3, autoSignDarwinBinariesHook, cctools }:
# Like many google projects, shaderc doesn't gracefully support separately compiled dependencies, so we can't easily use
# the versions of glslang and spirv-tools used by vulkan-loader. Exact revisions are taken from
# https://github.com/google/shaderc/blob/known-good/known_good.json

# Future work: extract and fetch all revisions automatically based on a revision of shaderc's known-good branch.
let
  glslang = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "glslang";
    rev = "a91631b260cba3f22858d6c6827511e636c2458a";
    hash = "sha256-7kIIU45pe+IF7lGltpIKSvQBmcXR+TWFvmx7ztMNrpc=";
  };
  spirv-tools = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Tools";
    rev = "f0cc85efdbbe3a46eae90e0f915dc1509836d0fc";
    hash = "sha256-RzGvoDt1Qc+f6mZsfs99MxX4YB3yFc5FP92Yx/WGrsI=";
  };
  spirv-headers = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "1c6bb2743599e6eb6f37b2969acc0aef812e32e3";
    hash = "sha256-/I9dJlBE0kvFvqooKuqMETtOE72Jmva3zIGnq0o4+aE=";
  };
in
stdenv.mkDerivation rec {
  pname = "shaderc";
  version = "2023.8";

  outputs = [ "out" "lib" "bin" "dev" "static" ];

  src = fetchFromGitHub {
    owner = "google";
    repo = "shaderc";
    rev = "v${version}";
    hash = "sha256-c8mJ361DY2VlSFZ4/RCrV+nqB9HblbOdfMkI4cM1QzM=";
  };

  patchPhase = ''
    cp -r --no-preserve=mode ${glslang} third_party/glslang
    cp -r --no-preserve=mode ${spirv-tools} third_party/spirv-tools
    ln -s ${spirv-headers} third_party/spirv-tools/external/spirv-headers
    patchShebangs --build utils/
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
