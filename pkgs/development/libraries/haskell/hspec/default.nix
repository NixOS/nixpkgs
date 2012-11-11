{ cabal, ansiTerminal, filepath, hspecExpectations, HUnit
, QuickCheck, setenv, silently, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "hspec";
  version = "1.4.1";
  sha256 = "02zwznhm075gx51yyx5nqgvks9gkr4pdhywxr9avnw6f470ph9ng";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    ansiTerminal filepath hspecExpectations HUnit QuickCheck setenv
    silently time transformers
  ];
  meta = {
    homepage = "http://hspec.github.com/";
    description = "Behavior Driven Development for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
