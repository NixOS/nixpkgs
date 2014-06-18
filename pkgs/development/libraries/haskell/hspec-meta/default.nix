{ cabal, ansiTerminal, async, deepseq, filepath, hspecExpectations
, HUnit, QuickCheck, quickcheckIo, random, setenv, tfRandom, time
, transformers
}:

cabal.mkDerivation (self: {
  pname = "hspec-meta";
  version = "1.10.0";
  sha256 = "1x32wgrd1i6rs6790dbr51j9g6abjpcf951cx3nmm4zdcwblyi6a";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    ansiTerminal async deepseq filepath hspecExpectations HUnit
    QuickCheck quickcheckIo random setenv tfRandom time transformers
  ];
  doCheck = false;
  meta = {
    homepage = "http://hspec.github.io/";
    description = "A version of Hspec which is used to test Hspec itself";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
