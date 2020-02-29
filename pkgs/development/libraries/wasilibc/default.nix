{ stdenv, fetchFromGitHub, lib }:

stdenv.mkDerivation {
  name = "wasilibc-20200227";
  src = fetchFromGitHub {
    owner = "CraneStation";
    repo = "wasi-libc";
    rev = "d9066a87c04748e7381695eaf01cc5c9a9c3003b";
    sha256 = "0103bm6arj18sf8bm9lgj3b64aa2znflpjwca33jm83jpbf8h0ry";
  };

  preBuild = ''
    makeFlagsArray=( WASM_CFLAGS="-isystem sysroot/include -isystem ../sysroot/include" )
  '';

  makeFlags = [
    "WASM_CC=${stdenv.cc.targetPrefix}cc"
    "WASM_NM=${stdenv.cc.targetPrefix}nm"
    "WASM_AR=${stdenv.cc.targetPrefix}ar"
    "INSTALL_DIR=${placeholder "out"}"
  ];

  enableParallelBuilding = true;

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
