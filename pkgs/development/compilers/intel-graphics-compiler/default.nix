{ lib
, stdenv
, fetchFromGitHub
, cmake
, runCommandLocal
, bison
, flex
, llvmPackages_11
, lld_11
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
    rev = "v0.3.0";
    sha256 = "sha256-1Rm4TCERTOcPGWJF+yNoKeB9x3jfqnh7Vlv+0Xpmjbk=";
  };
  llvmPkgs = llvmPackages_11 // {
    inherit spirv-llvm-translator;
  };
  inherit (llvmPkgs) llvm;
  inherit (if buildWithPatches then opencl-clang else llvmPkgs) clang libclang spirv-llvm-translator;
  inherit (lib) getVersion optional optionals versionOlder versions;
in

stdenv.mkDerivation rec {
  pname = "intel-graphics-compiler";
  version = "1.0.11061";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "intel-graphics-compiler";
    rev = "igc-${version}";
    sha256 = "sha256-qS/+GTqHtp3T6ggPKrCDsrTb7XvVOUaNbMzGU51jTu4=";
  };

  nativeBuildInputs = [ clang cmake bison flex python3 ];

  buildInputs = [ spirv-headers spirv-tools clang opencl-clang spirv-llvm-translator llvm lld_11 ];

  strictDeps = true;

  # checkInputs = [ lit pythonPackages.nose ];

  # FIXME: How do we run the test suite?
  # https://github.com/intel/intel-graphics-compiler/issues/98
  doCheck = false;

  postPatch = ''
    substituteInPlace ./external/SPIRV-Tools/CMakeLists.txt \
      --replace '$'''{SPIRV-Tools_DIR}../../..' \
                '${spirv-tools}' \
      --replace 'SPIRV-Headers_INCLUDE_DIR "/usr/include"' \
                'SPIRV-Headers_INCLUDE_DIR "${spirv-headers}/include"' \
      --replace 'set_target_properties(SPIRV-Tools' \
                'set_target_properties(SPIRV-Tools-shared' \
      --replace 'IGC_BUILD__PROJ__SPIRV-Tools SPIRV-Tools' \
                'IGC_BUILD__PROJ__SPIRV-Tools SPIRV-Tools-shared'
    substituteInPlace ./IGC/AdaptorOCL/igc-opencl.pc.in \
      --replace '/@CMAKE_INSTALL_INCLUDEDIR@' "/include" \
      --replace '/@CMAKE_INSTALL_LIBDIR@' "/lib"
  '';

  # Handholding the braindead build script
  # cmake requires an absolute path
  prebuilds = runCommandLocal "igc-cclang-prebuilds" { } ''
    mkdir $out
    ln -s ${clang}/bin/clang $out/
    ln -s clang $out/clang-${versions.major (getVersion clang)}
    ln -s ${opencl-clang}/lib/* $out/
    ln -s ${lib.getLib libclang}/lib/clang/${getVersion clang}/include/opencl-c.h $out/
    ln -s ${lib.getLib libclang}/lib/clang/${getVersion clang}/include/opencl-c-base.h $out/
  '';

  cmakeFlags = [
    "-Wno-dev"
    "-DVC_INTRINSICS_SRC=${vc_intrinsics_src}"
    "-DIGC_OPTION__SPIRV_TOOLS_MODE=Prebuilds"
    "-DCCLANG_BUILD_PREBUILDS=ON"
    "-DCCLANG_BUILD_PREBUILDS_DIR=${prebuilds}"
    "-DIGC_PREFERRED_LLVM_VERSION=${getVersion llvm}"
  ];

  meta = with lib; {
    homepage = "https://github.com/intel/intel-graphics-compiler";
    description = "LLVM-based compiler for OpenCL targeting Intel Gen graphics hardware";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ gloaming ];
    broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/intel-graphics-compiler.x86_64-darwin
  };
}
