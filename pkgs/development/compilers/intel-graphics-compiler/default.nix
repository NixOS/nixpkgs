{ lib
, stdenv
, fetchFromGitHub
, cmake
, runCommandLocal
, bison
, flex
, llvmPackages_14
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
    rev = "v0.13.0";
    hash = "sha256-A9G1PH0WGdxU2u/ODrou53qF9kvrmE0tJSl9cFIOus0=";
  };

  inherit (llvmPackages_14) lld llvm;
  inherit (if buildWithPatches then opencl-clang else llvmPackages_14) clang libclang;
  spirv-llvm-translator' = spirv-llvm-translator.override { inherit llvm; };
in

stdenv.mkDerivation rec {
  pname = "intel-graphics-compiler";
  version = "1.0.14828.8";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "intel-graphics-compiler";
    rev = "igc-${version}";
    hash = "sha256-BGmZVBEw7XlgbQcWgRK+qbJS9U4Sm9G8g9m0GRUhmCI=";
  };

  nativeBuildInputs = [ bison cmake flex python3 ];

  buildInputs = [ lld llvm spirv-headers spirv-llvm-translator' spirv-tools ];

  strictDeps = true;

  # testing is done via intel-compute-runtime
  doCheck = false;

  postPatch = ''
    substituteInPlace IGC/AdaptorOCL/igc-opencl.pc.in \
      --replace '/@CMAKE_INSTALL_INCLUDEDIR@' "/include" \
      --replace '/@CMAKE_INSTALL_LIBDIR@' "/lib"
  '';

  # Handholding the braindead build script
  # cmake requires an absolute path
  prebuilds = runCommandLocal "igc-cclang-prebuilds" { } ''
    mkdir $out
    ln -s ${clang}/bin/clang $out/
    ln -s ${opencl-clang}/lib/* $out/
    ln -s ${lib.getLib libclang}/lib/clang/${lib.getVersion clang}/include/opencl-c.h $out/
    ln -s ${lib.getLib libclang}/lib/clang/${lib.getVersion clang}/include/opencl-c-base.h $out/
  '';

  cmakeFlags = [
    "-DVC_INTRINSICS_SRC=${vc_intrinsics_src}"
    "-DCCLANG_BUILD_PREBUILDS=ON"
    "-DCCLANG_BUILD_PREBUILDS_DIR=${prebuilds}"
    "-DIGC_OPTION__SPIRV_TOOLS_MODE=Prebuilds"
    "-DIGC_OPTION__VC_INTRINSICS_MODE=Source"
    "-Wno-dev"
  ];

  meta = with lib; {
    homepage = "https://github.com/intel/intel-graphics-compiler";
    description = "LLVM-based compiler for OpenCL targeting Intel Gen graphics hardware";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
