{ cabal, annotatedWlPprint, ansiTerminal, ansiWlPprint, binary
, boehmgc, Cabal, cheapskate, deepseq, filepath, gmp, happy
, haskeline, languageJava, lens, libffi, llvmGeneral
, llvmGeneralPure, mtl, network, parsers, split, text, time
, transformers, trifecta, unorderedContainers, utf8String, vector
, vectorBinaryInstances, xml, zlib
}:

cabal.mkDerivation (self: {
  pname = "idris";
  version = "0.9.12";
  sha256 = "151h9qkx7yw24q0b60r78hki1y8m6sxmfars7wywnbzk3kalqb6x";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    annotatedWlPprint ansiTerminal ansiWlPprint binary Cabal cheapskate
    deepseq filepath haskeline languageJava lens libffi llvmGeneral
    llvmGeneralPure mtl network parsers split text time transformers
    trifecta unorderedContainers utf8String vector
    vectorBinaryInstances xml zlib
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
