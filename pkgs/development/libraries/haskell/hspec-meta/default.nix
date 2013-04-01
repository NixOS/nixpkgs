{ cabal, ansiTerminal, filepath, hspecExpectations, HUnit
, QuickCheck, quickcheckIo, setenv, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "hspec-meta";
  version = "1.5.1";
  sha256 = "1js62n2mxv4mj4w89ymz5cn3d2qznjndzk3c78gmy6chvig23zlf";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    ansiTerminal filepath hspecExpectations HUnit QuickCheck
    quickcheckIo setenv time transformers
  ];
  doCheck = false;
  meta = {
    homepage = "http://hspec.github.com/";
    description = "A version of Hspec which is used to test Hspec itself";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
