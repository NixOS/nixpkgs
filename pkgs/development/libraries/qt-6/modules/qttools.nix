{ qtModule
, stdenv
, lib
, qtbase
, qtdeclarative
, cups
<<<<<<< HEAD
, llvmPackages
# clang-based c++ parser for qdoc and lupdate
, withClang ? false
=======
, substituteAll
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

qtModule {
  pname = "qttools";
<<<<<<< HEAD
  buildInputs = lib.optionals withClang [
    llvmPackages.libclang
    llvmPackages.llvm
  ];
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  qtInputs = [ qtbase qtdeclarative ];
  propagatedBuildInputs = lib.optionals stdenv.isDarwin [ cups ];
  patches = [
    ../patches/qttools-paths.patch
  ];
  env.NIX_CFLAGS_COMPILE = toString [
    "-DNIX_OUTPUT_OUT=\"${placeholder "out"}\""
  ];
  postInstall = ''
    mkdir -p "$dev"
    ln -s "$out/bin" "$dev/bin"
  '';
}
