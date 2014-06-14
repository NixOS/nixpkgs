{ cabal, aeson, haskellSrcMeta, hspec, parsec, text, vector }:

cabal.mkDerivation (self: {
  pname = "aeson-qq";
  version = "0.7.1";
  sha256 = "1b2ham1h6mlm49ax9k2agf8yymbgkk094nq2apn703i2d9v00im6";
  buildDepends = [ aeson haskellSrcMeta parsec text vector ];
  testDepends = [ aeson hspec ];
  meta = {
    homepage = "http://github.com/zalora/aeson-qq";
    description = "JSON quasiquoter for Haskell";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
