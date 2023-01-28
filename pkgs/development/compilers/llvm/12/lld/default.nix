{ lib, stdenv, llvm_meta
, buildLlvmTools
, fetch
, libunwind
, cmake
, libxml2
, libllvm
, version
}:

stdenv.mkDerivation rec {
  pname = "lld";
  inherit version;

  src = fetch pname "0qg3fgc7wj34hdkqn21y03zcmsdd01szhhm1hfki63iifrm3y2v9";

  patches = [
    ./gnu-install-dirs.patch
  ];

  postPatch = ''
    substituteInPlace MachO/CMakeLists.txt --replace \
      '(''${LLVM_MAIN_SRC_DIR}/' '('
    mkdir -p libunwind/include
    tar -xf "${libunwind.src}" --wildcards -C libunwind/include --strip-components=2 "libunwind-*/include/"
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libllvm libxml2 ];

  cmakeFlags = [
    "-DLLVM_CONFIG_PATH=${libllvm.dev}/bin/llvm-config${lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) "-native"}"
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
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
