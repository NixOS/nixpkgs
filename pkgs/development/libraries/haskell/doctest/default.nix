{ cabal, deepseq, filepath, ghcPaths, hspec, HUnit, QuickCheck
, setenv, silently, stringbuilder, syb, transformers
}:

cabal.mkDerivation (self: {
  pname = "doctest";
  version = "0.9.10.1";
  sha256 = "1kl6bihhyj08ifij7ddpy6067s1lv2lnnp4an9wany3fzwlifbyi";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ deepseq filepath ghcPaths syb transformers ];
  testDepends = [
    deepseq filepath ghcPaths hspec HUnit QuickCheck setenv silently
    stringbuilder syb transformers
  ];
  doCheck = false;
  noHaddock = self.stdenv.lib.versionOlder self.ghc.version "7.4";
  meta = {
    homepage = "https://github.com/sol/doctest-haskell#readme";
    description = "Test interactive Haskell examples";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
