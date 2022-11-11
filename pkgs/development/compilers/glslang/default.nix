{ lib, stdenv
, fetchFromGitHub
, bison
, cmake
, jq
, python3
, spirv-headers
, spirv-tools
}:
stdenv.mkDerivation rec {
  pname = "glslang";
  version = "1.3.231.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "glslang";
    rev = "sdk-${version}";
    hash = "sha256-huPrQr+lPi7QCF8CufAavHEKGDDimGrcskiojhH9QYk=";
  };

  # These get set at all-packages, keep onto them for child drvs
  passthru = {
    spirv-tools = spirv-tools;
    spirv-headers = spirv-headers;
  };

  nativeBuildInputs = [ cmake python3 bison jq ];

  postPatch = ''
    cp --no-preserve=mode -r "${spirv-tools.src}" External/spirv-tools
    ln -s "${spirv-headers.src}" External/spirv-tools/external/spirv-headers
  '';

  # This is a dirty fix for lib/cmake/SPIRVTargets.cmake:51 which includes this directory
  postInstall = ''
    mkdir $out/include/External
  '';

  # Fix the paths in .pc, even though it's unclear if these .pc are really useful.
  postFixup = ''
    substituteInPlace "$out"/lib/pkgconfig/SPIRV-Tools{,-shared}.pc \
      --replace '=''${prefix}//' '=/'
  '';

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Khronos reference front-end for GLSL and ESSL";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = [ maintainers.ralith ];
  };
}
