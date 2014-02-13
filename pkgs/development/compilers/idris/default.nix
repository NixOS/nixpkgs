{ cabal, annotatedWlPprint, ansiTerminal, ansiWlPprint, binary
, boehmgc, Cabal, deepseq, filepath, gmp, happy, haskeline
, languageJava, libffi, llvmGeneral, llvmGeneralPure, mtl, network
, parsers, split, text, time, transformers, trifecta
, unorderedContainers, utf8String, vector, vectorBinaryInstances
, xml, zlib
}:

cabal.mkDerivation (self: {
  pname = "idris";
  version = "0.9.11.2";
  sha256 = "16xgiygn0j3kl3l36lnv6wz422nz2bvn3lk86xkdfvwjpv4630yn";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    annotatedWlPprint ansiTerminal ansiWlPprint binary Cabal deepseq
    filepath haskeline languageJava libffi llvmGeneral llvmGeneralPure
    mtl network parsers split text time transformers trifecta
    unorderedContainers utf8String vector vectorBinaryInstances xml
    zlib
  ];
  buildTools = [ happy ];
  extraLibraries = [ boehmgc gmp ];
  configureFlags = "-fllvm -fgmp -fffi";
  meta = {
    homepage = "http://www.idris-lang.org/";
    description = "Functional Programming Language with Dependent Types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
