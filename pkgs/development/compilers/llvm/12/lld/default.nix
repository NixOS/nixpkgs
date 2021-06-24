{ lib, stdenv, llvm_meta
, fetch
, libunwind
, cmake
, libxml2
, llvm
, version
}:

stdenv.mkDerivation rec {
  pname = "lld";
  inherit version;

  src = fetch pname "1zakyxk5bwnh7jarckcd4rbmzi58jgn2dbah5j5cwcyfyfbx9drc";

  nativeBuildInputs = [ cmake ];
  buildInputs = [ llvm libxml2 ];

  postPatch = ''
    substituteInPlace MachO/CMakeLists.txt --replace \
      '(''${LLVM_MAIN_SRC_DIR}/' '('
    mkdir -p libunwind/include
    tar -xf "${libunwind.src}" --wildcards -C libunwind/include --strip-components=2 "libunwind-*/include/"
  '';

  outputs = [ "out" "dev" ];

  postInstall = ''
    moveToOutput include "$dev"
    moveToOutput lib "$dev"
  '';

  meta = llvm_meta // {
    homepage = "https://lld.llvm.org/";
    description = "The LLVM linker";
    longDescription = ''
      LLD is a linker from the LLVM project that is a drop-in replacement for
      system linkers and runs much faster than them. It also provides features
      that are useful for toolchain developers.
      The linker supports ELF (Unix), PE/COFF (Windows), Mach-O (macOS) and
      WebAssembly in descending order of completeness. Internally, LLD consists
      of several different linkers.
    '';
  };
}
