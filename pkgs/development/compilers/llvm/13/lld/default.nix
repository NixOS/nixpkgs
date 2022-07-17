{ lib, stdenv, llvm_meta
, buildLlvmTools
, src
, cmake
, libxml2
, libllvm
, version
}:

stdenv.mkDerivation rec {
  pname = "lld";
  inherit version;

  inherit src;
  sourceRoot = "source/${pname}";

  patches = [
    ./gnu-install-dirs.patch
    ./lld-include-dir.patch
  ];

  # On Darwin the llvm-config is perhaps not working fine as the
  # LLVM_MAIN_SRC_DIR is not getting set correctly, and the build fails as the
  # include path is not correct.
  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace MachO/CMakeLists.txt --replace \
      '(''${LLVM_MAIN_SRC_DIR}/' '(../'
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libllvm libxml2 ];

  cmakeFlags = [
    "-DLLVM_CONFIG_PATH=${libllvm.dev}/bin/llvm-config${lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) "-native"}"
    "-DLLVM_MAIN_SRC_DIR=${libllvm.src}"
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "-DLLVM_TABLEGEN_EXE=${buildLlvmTools.llvm}/bin/llvm-tblgen"
  ];

  outputs = [ "out" "lib" "dev" ];

  meta = llvm_meta // {
    homepage = "https://lld.llvm.org/";
    description = "The LLVM linker";
    longDescription = ''
      LLD is a linker from the LLVM project that is a drop-in replacement for
      system linkers and runs much faster than them. It also provides features
      that are useful for toolchain developers.
      The linker supports ELF (Unix), PE/COFF (Windows), Mach-O (macOS), and
      WebAssembly in descending order of completeness. Internally, LLD consists
      of several different linkers.
    '';
  };
}
