{ cabal, baseCompat, deepseq, filepath, ghcPaths, hspec, HUnit
, QuickCheck, setenv, silently, stringbuilder, syb, transformers
}:

cabal.mkDerivation (self: {
  pname = "doctest";
  version = "0.9.5.1";
  sha256 = "0phakf605pdwp89y522wm17n1bflxlgqkgahklnf10wnywxwm7cs";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ deepseq filepath ghcPaths syb transformers ];
  testDepends = [
    baseCompat deepseq filepath ghcPaths hspec HUnit QuickCheck setenv
    silently stringbuilder syb transformers
  ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/sol/doctest-haskell#readme";
    description = "Test interactive Haskell examples";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
