{ stdenv, fetchFromGitHub, lib }:

stdenv.mkDerivation {
  name = "wasilibc-20190413";
  src = fetchFromGitHub {
    owner = "CraneStation";
    repo = "wasi-sysroot";
    rev = "079d7bda78bc0ad8f69c1594444b54786545ce57";
    sha256 = "09s906bc9485wzkgibnpfh0mii7jkldzr1a6g8k7ch0si8rshi5r";
  };
  makeFlags = [
    "WASM_CC=${stdenv.cc.targetPrefix}cc"
    "WASM_NM=${stdenv.cc.targetPrefix}nm"
    "WASM_AR=${stdenv.cc.targetPrefix}ar"
    "INSTALL_DIR=${placeholder "out"}"
  ];

  postInstall = ''
    mv $out/lib/*/* $out/lib
    ln -s $out/share/wasm32-wasi/undefined-symbols.txt $out/lib/wasi.imports
  '';

  meta = {
    description = "WASI libc implementation for WebAssembly";
    homepage    = "https://wasi.dev";
    platforms   = lib.platforms.wasi;
    maintainers = [ lib.maintainers.matthewbauer ];
  };
}
