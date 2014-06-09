{ cabal, aeson, haskellSrcMeta, hspec, parsec, text, vector }:

cabal.mkDerivation (self: {
  pname = "aeson-qq";
  version = "0.7.0";
  sha256 = "1sq34pnwiyf5lngqph4m463ijr185akzbrdi3i40zmqlrymssv3c";
  buildDepends = [ aeson haskellSrcMeta parsec text vector ];
  testDepends = [ aeson hspec ];
  meta = {
    homepage = "http://github.com/zalora/aeson-qq";
    description = "JSON quasiquoter for Haskell";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
