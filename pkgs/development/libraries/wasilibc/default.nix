{ stdenv, llvm-tools, fetchFromGitHub, lib }:

stdenv.mkDerivation {
  name = "wasilibc-20200227";
  src = fetchFromGitHub {
    owner = "CraneStation";
    repo = "wasi-libc";
    rev = "d9066a87c04748e7381695eaf01cc5c9a9c3003b";
    sha256 = "0103bm6arj18sf8bm9lgj3b64aa2znflpjwca33jm83jpbf8h0ry";
  };

  makeFlagsArray = stdenv.lib.optional stdenv.cc.isClang [
    "WASM_CFLAGS=-O2 -DNDEBUG -U_FORTIFY_SOURCE -fno-pic -fno-stack-protector -isystem sysroot/include -isystem ../sysroot/include"
  ];

  makeFlags = if stdenv.cc.isClang then [
    "WASM_CC=${stdenv.cc.targetPrefix}cc"
    "WASM_NM=${llvm-tools}/bin/llvm-nm"
    "WASM_AR=${llvm-tools}/bin/llvm-ar"
    "INSTALL_DIR=${placeholder "out"}"
  ] else [
    "WASM_CC=${stdenv.cc.targetPrefix}cc"
    "WASM_NM=${stdenv.cc.targetPrefix}nm"
    "WASM_AR=${stdenv.cc.targetPrefix}ar"
    "INSTALL_DIR=${placeholder "out"}"
  ];

  enableParallelBuilding = true;

  postInstall = ''
    mv $out/lib/*/* $out/lib
    rm -r $out/lib/wasm32-wasi
    ln -s $out/lib $out/lib/wasm32-wasi
    ln -s $out/share/wasm32-wasi/undefined-symbols.txt $out/lib/wasi.imports
  '';

  meta = {
    description = "WASI libc implementation for WebAssembly";
    homepage    = "https://wasi.dev";
    platforms   = lib.platforms.wasi;
    maintainers = [ lib.maintainers.matthewbauer ];
  };
}
