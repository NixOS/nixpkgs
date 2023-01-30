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
  version = "1.3.239.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "glslang";
    rev = "sdk-${version}";
    hash = "sha256-P2HG/oJXdB5nvU3zVnj2vSLJGQuDcZiQBfBBvuR66Kk=";
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
    # Upstream tries to detect the Darwin linker by checking for AppleClang, but it’s just Clang in nixpkgs.
    # Revert the commit to allow the build to work on Darwin with the nixpkg Darwin Clang toolchain.
    (fetchpatch {
      name = "Fix-Darwin-linker-error.patch";
      url = "https://github.com/KhronosGroup/glslang/commit/586baa35a47b3aa6ad3fa829a27f0f4206400668.patch";
      hash = "sha256-paAl4E8GzogcxDEzn/XuhNH6XObp+i7WfArqAiuH4Mk=";
      revert = true;
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
