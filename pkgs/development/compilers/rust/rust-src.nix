{ lib, stdenv, rustc, minimalContent ? true }:

stdenv.mkDerivation {
  name = "rust-src";
  src = rustc.src;
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
    mv src $out
    rm -rf $out/{${lib.concatStringsSep "," ([
      "ci"
      "doc"
      "etc"
      "grammar"
      "llvm-project"
      "llvm-emscripten"
      "rtstartup"
      "rustllvm"
      "test"
      "vendor"
    ] ++ lib.optionals minimalContent [
      "tools"
      "stdarch"
    ])}}
  '';
}
