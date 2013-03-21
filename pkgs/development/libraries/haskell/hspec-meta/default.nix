{ cabal, ansiTerminal, filepath, hspecExpectations, HUnit
, QuickCheck, setenv, silently, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "hspec-meta";
  version = "1.4.5";
  sha256 = "0k50vwzg3ka4727bj63y4gsvw4g80gnalj31rsbvj3afl9gikkk7";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    ansiTerminal filepath hspecExpectations HUnit QuickCheck setenv
    silently time transformers
  ];
  doCheck = false;
  meta = {
    homepage = "http://hspec.github.com/";
    description = "A version of Hspec which is used to test Hspec itself";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
