{ stdenv, rustc, minimalContent ? true }:

stdenv.mkDerivation {
  name = "rust-src";
  src = rustc.src;
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
    mv src $out
    rm -rf $out/{${if minimalContent
      then "ci,doc,etc,grammar,llvm-project,llvm-emscripten,rtstartup,rustllvm,test,tools,vendor,stdarch"
      else "ci,doc,etc,grammar,llvm-project,llvm-emscripten,rtstartup,rustllvm,test,vendor"
    }}
  '';
}
