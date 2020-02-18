{ stdenv, rustc }:

stdenv.mkDerivation {
  name = "rust-src";
  src = rustc.src;
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
    mv src $out
    rm -rf $out/{ci,doc,driver,etc,grammar,llvm,rt,rtstartup,rustllvm,test,tools,vendor}
  '';
}
