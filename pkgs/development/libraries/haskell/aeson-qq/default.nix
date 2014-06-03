{ cabal, aeson, haskellSrcMeta, hspec, parsec, text, vector }:

cabal.mkDerivation (self: {
  pname = "aeson-qq";
  version = "0.6.1";
  sha256 = "164nqk1qfb8a9c95yv5hg0zgcjcg49vrra2wi00h325bgpq6wa5n";
  buildDepends = [ aeson haskellSrcMeta parsec text vector ];
  testDepends = [ aeson hspec ];
  meta = {
    homepage = "http://github.com/zalora/aeson-qq";
    description = "Json Quasiquatation for Haskell";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
