{ lib
, stdenv
, fetchFromGitHub
, cmake
, runCommandLocal
, bison
, flex
, llvmPackages_8
, opencl-clang
, python3
, spirv-llvm-translator

, buildWithPatches ? true
}:

let
  llvmPkgs = llvmPackages_8 // {
    inherit spirv-llvm-translator;
  };
  inherit (llvmPkgs) llvm;
  inherit (if buildWithPatches then opencl-clang else llvmPkgs) clang libclang spirv-llvm-translator;
  inherit (lib) getVersion optional optionals versionOlder versions;
in

stdenv.mkDerivation rec {
  pname = "intel-graphics-compiler";
  version = "1.0.4241";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "intel-graphics-compiler";
    rev = "igc-${version}";
    sha256 = "1jp3c67ppl1x4pazr5nzy52615cpx0kyckaridhc0fsmrkgilyxq";
  };

  nativeBuildInputs = [ clang cmake bison flex python3 ];

  buildInputs = [ clang opencl-clang spirv-llvm-translator llvm ];

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
  '';

  cmakeFlags = [
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
  };
}
