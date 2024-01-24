{ lib
, stdenv
, fetchFromGitHub
, cmake
, runCommandLocal
, bison
, flex
, intel-compute-runtime
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
    rev = "v0.14.0";
    hash = "sha256-t7m2y+DiZf0xum1vneXvoCyH767SKMOq4YzMIuZngR8=";
  };

  inherit (llvmPackages_14) lld llvm;
  inherit (if buildWithPatches then opencl-clang else llvmPackages_14) clang libclang;
  spirv-llvm-translator' = spirv-llvm-translator.override { inherit llvm; };
in

stdenv.mkDerivation rec {
  pname = "intel-graphics-compiler";
  version = "1.0.15610.11";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "intel-graphics-compiler";
    rev = "igc-${version}";
    hash = "sha256-Fu1g5M2lpcnLw6aSHI5gx47VOfx+rIdIhBlwe/Dv8bk=";
  };

  nativeBuildInputs = [ bison cmake flex (python3.withPackages (ps : with ps; [ mako ])) ];

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

  passthru.tests = {
    inherit intel-compute-runtime;
  };

  meta = with lib; {
    homepage = "https://github.com/intel/intel-graphics-compiler";
    description = "LLVM-based compiler for OpenCL targeting Intel Gen graphics hardware";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
