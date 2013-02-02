{ cabal, deepseq, filepath, ghcPaths, syb, transformers }:

cabal.mkDerivation (self: {
  pname = "doctest";
  version = "0.9.5";
  sha256 = "073q56gyhkb7r4f94b9nx341dkmgapy8gig7f668jkghv2zci5ws";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ deepseq filepath ghcPaths syb transformers ];
  meta = {
    homepage = "https://github.com/sol/doctest-haskell#readme";
    description = "Test interactive Haskell examples";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
