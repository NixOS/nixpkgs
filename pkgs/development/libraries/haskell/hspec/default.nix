{ cabal, ansiTerminal, filepath, hspecExpectations, HUnit
, QuickCheck, setenv, silently, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "hspec";
  version = "1.4.4";
  sha256 = "09wrvdlqzpa3vjcnirnzpj8nsvqnn5xbilnxaqmjm2agbl8xfj5r";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    ansiTerminal filepath hspecExpectations HUnit QuickCheck setenv
    silently time transformers
  ];
  meta = {
    homepage = "http://hspec.github.com/";
    description = "Behavior-Driven Development for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
