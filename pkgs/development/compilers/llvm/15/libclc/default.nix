{ lib
, stdenv
, llvm_meta
, monorepoSrc
, runCommand
, cmake
, ninja
, python3
, llvm
, targetLlvm
, clang-unwrapped
, spirv-llvm-translator
, version
} @ args:

let
  llvm = if stdenv.buildPlatform == stdenv.hostPlatform then args.llvm else targetLlvm;
  spirv = spirv-llvm-translator.override {
    llvm = args.llvm; # use LLVM for the build platform here, not targetLlvm
  };
in

stdenv.mkDerivation rec {
  pname = "libclc";
  inherit version;

  src = runCommand "${pname}-src-${version}" {} ''
    mkdir -p "$out"
    cp -r ${monorepoSrc}/cmake "$out"
    cp -r ${monorepoSrc}/${pname} "$out"
  '';
  sourceRoot = "${src.name}/${pname}";

  # cmake expects all required binaries to be in the same place, so it will not be able to find clang without the patch
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace 'find_program( LLVM_CLANG clang PATHS ''${LLVM_BINDIR} NO_DEFAULT_PATH )' \
                'find_program( LLVM_CLANG clang PATHS "${clang-unwrapped}/bin" NO_DEFAULT_PATH )' \
      --replace 'find_program( LLVM_SPIRV llvm-spirv PATHS ''${LLVM_BINDIR} NO_DEFAULT_PATH )' \
                'find_program( LLVM_SPIRV llvm-spirv PATHS "${spirv}/bin" NO_DEFAULT_PATH )'
  '';

  nativeBuildInputs = [ cmake ninja python3 spirv ];
  buildInputs = [ llvm clang-unwrapped ];
  strictDeps = true;
  cmakeFlags = [
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ];

  meta = llvm_meta // {
    homepage = "http://libclc.llvm.org/";
    description = "Implementation of the library requirements of the OpenCL C programming language";
    broken = stdenv.isDarwin;
  };
}
