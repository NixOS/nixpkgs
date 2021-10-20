{ stdenv, fetchFromGitHub, lib }:

stdenv.mkDerivation {
  pname = "wasilibc";
  version = "20190712";
  src = fetchFromGitHub {
    owner = "CraneStation";
    repo = "wasi-libc";
    rev = "8df0d4cd6a559b58d4a34b738a5a766b567448cf";
    sha256 = "1n4gvgzacpagar2mx8g9950q0brnhwz7jg2q44sa5mnjmlnkiqhh";
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

  meta = with lib; {
    description = "WASI libc implementation for WebAssembly";
    homepage    = "https://wasi.dev";
    platforms   = platforms.wasi;
    maintainers = [ maintainers.matthewbauer ];
    license = with licenses; [ asl20 mit llvm-exception ];
  };
}
