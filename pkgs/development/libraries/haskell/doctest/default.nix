{ cabal, baseCompat, deepseq, filepath, ghcPaths, hspec, HUnit
, QuickCheck, setenv, silently, stringbuilder, syb, transformers
}:

cabal.mkDerivation (self: {
  pname = "doctest";
  version = "0.9.8";
  sha256 = "0c1qi1dfqndbkaiksffw54gv6nlhd3wsk25s97vhrgmpd3n7sb8a";
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
