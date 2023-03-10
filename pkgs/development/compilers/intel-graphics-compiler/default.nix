{ lib
, stdenv
, fetchFromGitHub
, cmake
, runCommandLocal
, bison
, flex
, llvmPackages_11
, opencl-clang
, python3
, spirv-tools
, spirv-headers
, spirv-llvm-translator

, buildWithPatches ? true
}:

let
  vc_intrinsics_src = fetchFromGitHub {
    owner = "intel";
    repo = "vc-intrinsics";
    rev = "v0.11.0";
    sha256 = "sha256-74JBW7qU8huSqwqgxNbvbGj1DlJJThgGhb3owBYmhvI=";
  };

  llvmPkgs = llvmPackages_11 // {
    spirv-llvm-translator = spirv-llvm-translator.override { llvm = llvm; };
  } // lib.optionalAttrs buildWithPatches opencl-clang;

  inherit (llvmPackages_11) lld llvm;
  inherit (llvmPkgs) clang libclang spirv-llvm-translator;
in

stdenv.mkDerivation rec {
  pname = "intel-graphics-compiler";
  version = "1.0.12812.26";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "intel-graphics-compiler";
    rev = "igc-${version}";
    sha256 = "sha256-KpaDaDYVp40H7OscDGUpzEMgIOIk397ANi+8sDk4Wow=";
  };

  nativeBuildInputs = [ cmake bison flex python3 ];

  buildInputs = [ spirv-headers spirv-tools spirv-llvm-translator llvm lld ];

  strictDeps = true;

  # testing is done via intel-compute-runtime
  doCheck = false;

  postPatch = ''
    substituteInPlace external/SPIRV-Tools/CMakeLists.txt \
      --replace '$'''{SPIRV-Tools_DIR}../../..' \
                '${spirv-tools}' \
      --replace 'SPIRV-Headers_INCLUDE_DIR "/usr/include"' \
                'SPIRV-Headers_INCLUDE_DIR "${spirv-headers}/include"' \
      --replace 'set_target_properties(SPIRV-Tools' \
                'set_target_properties(SPIRV-Tools-shared' \
      --replace 'IGC_BUILD__PROJ__SPIRV-Tools SPIRV-Tools' \
                'IGC_BUILD__PROJ__SPIRV-Tools SPIRV-Tools-shared'
    substituteInPlace IGC/AdaptorOCL/igc-opencl.pc.in \
      --replace '/@CMAKE_INSTALL_INCLUDEDIR@' "/include" \
      --replace '/@CMAKE_INSTALL_LIBDIR@' "/lib"
  '';

  # Handholding the braindead build script
  # cmake requires an absolute path
  prebuilds = runCommandLocal "igc-cclang-prebuilds" { } ''
    mkdir $out
    ln -s ${clang}/bin/clang $out/
    ln -s clang $out/clang-${lib.versions.major (lib.getVersion clang)}
    ln -s ${opencl-clang}/lib/* $out/
    ln -s ${lib.getLib libclang}/lib/clang/${lib.getVersion clang}/include/opencl-c.h $out/
    ln -s ${lib.getLib libclang}/lib/clang/${lib.getVersion clang}/include/opencl-c-base.h $out/
  '';

  cmakeFlags = [
    "-Wno-dev"
    "-DVC_INTRINSICS_SRC=${vc_intrinsics_src}"
    "-DIGC_OPTION__SPIRV_TOOLS_MODE=Prebuilds"
    "-DCCLANG_BUILD_PREBUILDS=ON"
    "-DCCLANG_BUILD_PREBUILDS_DIR=${prebuilds}"
    "-DIGC_PREFERRED_LLVM_VERSION=${lib.getVersion llvm}"
  ];

  meta = with lib; {
    homepage = "https://github.com/intel/intel-graphics-compiler";
    description = "LLVM-based compiler for OpenCL targeting Intel Gen graphics hardware";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
