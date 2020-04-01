{ stdenv, llvm-tools, fetchFromGitHub, lib }:

stdenv.mkDerivation {
  name = "wasilibc-20200319";
  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "wasi-libc";
    rev = "9efc2f428358564fe64c374d762d0bfce1d92507";
    sha256 = "1q6h9r1h7j3i3r8rj2mpjarqa69cbb7frbws3ij7y3x6nbp0znh7";
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
    # platforms   = lib.platforms.wasi; TODO: include Darwin 64-bit
    maintainers = [ lib.maintainers.matthewbauer ];
  };
}
