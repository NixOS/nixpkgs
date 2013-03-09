{ cabal, ansiTerminal, filepath, hspecExpectations, HUnit
, QuickCheck, setenv, silently, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "hspec-meta";
  version = "1.4.4";
  sha256 = "1p1miiaa38rd92bz695znlwd6wyvs8zpp2idyw5pkzvhqi8w10a1";
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
