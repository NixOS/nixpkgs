{ stdenv, rustc }:

stdenv.mkDerivation {
  name = "rust-src";
  src = rustc.src;
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
    mv src $out
    rm -rf $out/{ci,doc,etc,grammar,llvm-project,llvm-emscripten,rtstartup,rustllvm,test,tools,vendor,stdarch}
  '';
}
