{ stdenv
, fetchFromGitHub
, cmake
, pkgconfig

, bison
, flex
, llvmPackages_8
, opencl-clang
, python
, spirv-llvm-translator

, buildWithPatches ? true
}:

let
  llvmPkgs = llvmPackages_8 // {
    inherit spirv-llvm-translator;
  };
  inherit (llvmPkgs) llvm;
  inherit (if buildWithPatches then opencl-clang else llvmPkgs) clang clang-unwrapped spirv-llvm-translator;
  inherit (stdenv.lib) getVersion optional optionals versionOlder versions;
in

stdenv.mkDerivation rec {
  pname = "intel-graphics-compiler";
  version = "1.0.3151";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "intel-graphics-compiler";
    rev = "igc-${version}";
    sha256 = "1c2ll563a2j4sv3r468i4lv158hkzywnyajyk7iyin7bhqhm2vzf";
  };

  nativeBuildInputs = [ clang cmake bison flex llvm python ];

  buildInputs = [ clang opencl-clang spirv-llvm-translator ];

  # checkInputs = [ lit pythonPackages.nose ];

  # FIXME: How do we run the test suite?
  # https://github.com/intel/intel-graphics-compiler/issues/98
  doCheck = false;

  # Handholding the braindead build script
  # We put this in a derivation because the cmake requires an absolute path
  prebuilds = stdenv.mkDerivation {
    name = "igc-cclang-prebuilds";
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir $out
      ln -s ${clang}/bin/clang $out/
      ln -s clang $out/clang-${versions.major (getVersion clang)}
      ln -s ${opencl-clang}/lib/* $out/
      ln -s ${clang-unwrapped}/lib/clang/${getVersion clang}/include/opencl-c.h $out/
    '';
  };

  cmakeFlags = [
    "-DCCLANG_BUILD_PREBUILDS=ON"
    "-DCCLANG_BUILD_PREBUILDS_DIR=${prebuilds}"
    "-DIGC_PREFERRED_LLVM_VERSION=${getVersion llvm}"
  ];

  meta = with stdenv.lib; {
    homepage    = https://github.com/intel/intel-graphics-compiler;
    description = "LLVM-based compiler for OpenCL targeting Intel Gen graphics hardware";
    license     = licenses.mit;
    platforms   = platforms.all;
    maintainers = with maintainers; [ gloaming ];
  };
}
