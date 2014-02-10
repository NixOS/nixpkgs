{ cabal, annotatedWlPprint, ansiTerminal, ansiWlPprint, binary
, boehmgc, Cabal, deepseq, filepath, gmp, happy, haskeline
, languageJava, libffi, llvmGeneral, llvmGeneralPure, mtl, network
, parsers, split, text, time, transformers, trifecta
, unorderedContainers, utf8String, vector, vectorBinaryInstances
, xml, zlib
}:

cabal.mkDerivation (self: {
  pname = "idris";
  version = "0.9.11.1";
  sha256 = "02a484vcf4sm2kdmxfxsy8x5whf002xyp2b6w1zrg7a6qggcabar";
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
