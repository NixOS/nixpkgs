{ cabal, ansiTerminal, async, deepseq, doctest, filepath, ghcPaths
, hspecExpectations, hspecMeta, HUnit, ioMemoize, QuickCheck
, quickcheckIo, random, setenv, silently, tfRandom, time
, transformers
}:

cabal.mkDerivation (self: {
  pname = "hspec2";
  version = "0.3.0";
  sha256 = "0ia19jraz2di31c48lh0kswkb2573jxm7msf33i8d5a5yq8y9wwp";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    ansiTerminal async deepseq filepath hspecExpectations HUnit
    ioMemoize QuickCheck quickcheckIo random setenv tfRandom time
    transformers
  ];
  testDepends = [
    ansiTerminal async deepseq doctest filepath ghcPaths
    hspecExpectations hspecMeta HUnit ioMemoize QuickCheck quickcheckIo
    random setenv silently tfRandom time transformers
  ];
  meta = {
    homepage = "http://hspec.github.io/";
    description = "Alpha version of Hspec 2.0";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
