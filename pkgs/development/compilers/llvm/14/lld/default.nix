{ lib, stdenv, llvm_meta
, buildLlvmTools
, monorepoSrc, runCommand
, cmake
, libxml2
, libllvm
, version
}:

stdenv.mkDerivation rec {
  pname = "lld";
  inherit version;

  # Blank llvm dir just so relative path works
  src = runCommand "${pname}-src-${version}" {} ''
    mkdir -p "$out"
    cp -r ${monorepoSrc}/cmake "$out"
    cp -r ${monorepoSrc}/${pname} "$out"
    mkdir -p "$out/libunwind"
    cp -r ${monorepoSrc}/libunwind/include "$out/libunwind"
    mkdir -p "$out/llvm"
  '';

  sourceRoot = "${src.name}/${pname}";

  patches = [
    ./gnu-install-dirs.patch
    # On Darwin the llvm-config is perhaps not working fine as the
    # LLVM_MAIN_SRC_DIR is not getting set correctly, and the build fails as
    # the include path is not correct.
    ./fix-root-src-dir.patch
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libllvm libxml2 ];

  cmakeFlags = lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "-DLLVM_TABLEGEN_EXE=${buildLlvmTools.llvm}/bin/llvm-tblgen"
  ];

  outputs = [ "out" "lib" "dev" ];

  meta = llvm_meta // {
    homepage = "https://lld.llvm.org/";
    description = "The LLVM linker (unwrapped)";
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
