{ cabal, stm, transformers }:

cabal.mkDerivation (self: {
  pname = "final";
  version = "0.1";
  sha256 = "189vby5ym6hcjpz6y9chlgkyzl8wnndqkhzk7s7qy8mksr3g66f9";
  buildDepends = [ stm transformers ];
  meta = {
    homepage = "http://github.com/errge/final";
    description = "utility to add extra safety to monadic returns";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
