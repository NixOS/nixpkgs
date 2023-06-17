{ lib, stdenv, fetchFromGitHub, buildPackages, ninja, cmake, python3, llvm_14 }:

stdenv.mkDerivation rec {
  pname = "libclc";
  version = "16.0.3";

  src = fetchFromGitHub {
    owner = "llvm";
    repo = "llvm-project";
    rev = "llvmorg-${version}";
    hash = "sha256-paWwnoU3XMqreRgh9JbT1tDMTwq/ZL0ss3SJTteEGL0=";
  };
  sourceRoot = "source/libclc";

  outputs = [ "out" "dev" ];

  patches = [
    ./libclc-gnu-install-dirs.patch
  ];

  # cmake expects all required binaries to be in the same place, so it will not be able to find clang without the patch
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace 'find_program( LLVM_CLANG clang PATHS ''${LLVM_TOOLS_BINARY_DIR} NO_DEFAULT_PATH )' \
                'find_program( LLVM_CLANG clang PATHS "${buildPackages.clang_14.cc}/bin" NO_DEFAULT_PATH )' \
      --replace 'find_program( LLVM_AS llvm-as PATHS ''${LLVM_TOOLS_BINARY_DIR} NO_DEFAULT_PATH )' \
                'find_program( LLVM_AS llvm-as PATHS "${buildPackages.llvm_14}/bin" NO_DEFAULT_PATH )' \
      --replace 'find_program( LLVM_LINK llvm-link PATHS ''${LLVM_TOOLS_BINARY_DIR} NO_DEFAULT_PATH )' \
                'find_program( LLVM_LINK llvm-link PATHS "${buildPackages.llvm_14}/bin" NO_DEFAULT_PATH )' \
      --replace 'find_program( LLVM_OPT opt PATHS ''${LLVM_TOOLS_BINARY_DIR} NO_DEFAULT_PATH )' \
                'find_program( LLVM_OPT opt PATHS "${buildPackages.llvm_14}/bin" NO_DEFAULT_PATH )' \
      --replace 'find_program( LLVM_SPIRV llvm-spirv PATHS ''${LLVM_TOOLS_BINARY_DIR} NO_DEFAULT_PATH )' \
                'find_program( LLVM_SPIRV llvm-spirv PATHS "${buildPackages.spirv-llvm-translator}/bin" NO_DEFAULT_PATH )'
  '' + lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    substituteInPlace CMakeLists.txt \
      --replace 'COMMAND prepare_builtins' 'COMMAND ${buildPackages.libclc.dev}/bin/prepare_builtins'
  '';

  nativeBuildInputs = [ cmake ninja python3 ];
  buildInputs = [ llvm_14 ];
  strictDeps = true;

  postInstall = ''
    install -Dt $dev/bin prepare_builtins
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "http://libclc.llvm.org/";
    description = "Implementation of the library requirements of the OpenCL C programming language";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
