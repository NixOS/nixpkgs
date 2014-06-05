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
  version = "0.9.13";
  sha256 = "0bpp8b19s1przycndvl542ar9dc285ccnwm7cic33ym1lcqil86n";
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
