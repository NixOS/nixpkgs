<<<<<<< HEAD
{ lib, stdenv, fetchFromGitHub, buildPackages, ninja, cmake, python3, llvm_14 }:

stdenv.mkDerivation rec {
  pname = "libclc";
  version = "16.0.3";
=======
{ lib, stdenv, fetchFromGitHub, ninja, cmake, python3, llvmPackages, spirv-llvm-translator }:

let
  llvm = llvmPackages.llvm;
  clang-unwrapped = llvmPackages.clang-unwrapped;
in

stdenv.mkDerivation rec {
  pname = "libclc";
  version = "15.0.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "llvm";
    repo = "llvm-project";
    rev = "llvmorg-${version}";
<<<<<<< HEAD
    hash = "sha256-paWwnoU3XMqreRgh9JbT1tDMTwq/ZL0ss3SJTteEGL0=";
  };
  sourceRoot = "${src.name}/libclc";

  outputs = [ "out" "dev" ];

  patches = [
    ./libclc-gnu-install-dirs.patch
  ];
=======
    sha256 = "sha256-wjuZQyXQ/jsmvy6y1aksCcEDXGBjuhpgngF3XQJ/T4s=";
  };
  sourceRoot = "source/libclc";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # cmake expects all required binaries to be in the same place, so it will not be able to find clang without the patch
  postPatch = ''
    substituteInPlace CMakeLists.txt \
<<<<<<< HEAD
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
=======
      --replace 'find_program( LLVM_CLANG clang PATHS ''${LLVM_BINDIR} NO_DEFAULT_PATH )' \
                'find_program( LLVM_CLANG clang PATHS "${clang-unwrapped}/bin" NO_DEFAULT_PATH )' \
      --replace 'find_program( LLVM_SPIRV llvm-spirv PATHS ''${LLVM_BINDIR} NO_DEFAULT_PATH )' \
                'find_program( LLVM_SPIRV llvm-spirv PATHS "${spirv-llvm-translator}/bin" NO_DEFAULT_PATH )'
  '';

  nativeBuildInputs = [ cmake ninja python3 spirv-llvm-translator ];
  buildInputs = [ llvm clang-unwrapped ];
  strictDeps = true;
  cmakeFlags = [
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "http://libclc.llvm.org/";
    description = "Implementation of the library requirements of the OpenCL C programming language";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
