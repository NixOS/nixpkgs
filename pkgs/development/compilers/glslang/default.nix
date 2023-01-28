{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, bison
, cmake
, jq
, python3
, spirv-headers
, spirv-tools
}:
stdenv.mkDerivation rec {
  pname = "glslang";
  version = "1.3.236.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "glslang";
    rev = "sdk-${version}";
    hash = "sha256-iVcx1j7OMJEU4cPydNwQSFufTUiqq7GKp69Y6pEt7Wc=";
  };

  # These get set at all-packages, keep onto them for child drvs
  passthru = {
    spirv-tools = spirv-tools;
    spirv-headers = spirv-headers;
  };

  nativeBuildInputs = [ cmake python3 bison jq ];

  patches = [
    (fetchpatch {
      name = "Use-CMAKE_INSTALL_FULL_LIBDIR-in-compat-cmake-files.patch";
      url = "https://github.com/KhronosGroup/glslang/commit/7627bd89583c5aafb8b38c81c15494019271fabf.patch";
      hash = "sha256-1Dwhn78PG4gAGgEwTXpC+mkZRyvy8sTIsEvihXFeNaQ=";
    })
  ];

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
