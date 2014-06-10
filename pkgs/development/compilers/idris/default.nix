{ cabal, annotatedWlPprint, ansiTerminal, ansiWlPprint, binary
, blazeHtml, blazeMarkup, boehmgc, Cabal, cheapskate, deepseq
, filepath, gmp, happy, haskeline, languageJava, lens, libffi
, llvmGeneral, llvmGeneralPure, mtl, network, optparseApplicative
, parsers, split, text, time, transformers, trifecta
, unorderedContainers, utf8String, vector, vectorBinaryInstances
, xml, zlib
}:

cabal.mkDerivation (self: {
  pname = "idris";
  version = "0.9.13.1";
  sha256 = "09528c2zxriw3l8c7dd2k5db9j1qmqhs6nbqwc7dkskzqv9snz7n";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    annotatedWlPprint ansiTerminal ansiWlPprint binary blazeHtml
    blazeMarkup Cabal cheapskate deepseq filepath haskeline
    languageJava lens libffi llvmGeneral llvmGeneralPure mtl network
    optparseApplicative parsers split text time transformers trifecta
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
