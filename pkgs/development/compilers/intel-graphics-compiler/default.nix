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
, spirv-llvm-translator

, buildWithPatches ? true
}:

let
  vc_intrinsics_src = fetchFromGitHub {
    owner = "intel";
    repo = "vc-intrinsics";
    rev = "e5ad7e02aa4aa21a3cd7b3e5d1f3ec9b95f58872";
    sha256 = "Vg1mngwpIQ3Tik0GgRXPG22lE4sLEAEFch492G2aIXs=";
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
  version = "1.0.8744";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "intel-graphics-compiler";
    rev = "igc-${version}";
    sha256 = "G5+dYD8uZDPkRyn1sgXsRngdq4NJndiCJCYTRXyUgTA=";
  };

  nativeBuildInputs = [ clang cmake bison flex python3 ];

  buildInputs = [ clang opencl-clang spirv-llvm-translator llvm lld_11 ];

  strictDeps = true;

  # checkInputs = [ lit pythonPackages.nose ];

  # FIXME: How do we run the test suite?
  # https://github.com/intel/intel-graphics-compiler/issues/98
  doCheck = false;

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
    "-DVC_INTRINSICS_SRC=${vc_intrinsics_src}"
    "-DINSTALL_SPIRVDLL=0"
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
