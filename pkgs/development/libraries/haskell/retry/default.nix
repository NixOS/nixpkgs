{ cabal, dataDefault, liftedBase, monadControl, transformers }:

cabal.mkDerivation (self: {
  pname = "retry";
  version = "0.3.0.0";
  sha256 = "00yjk5784h4w1cckw17w1k5r94acc3ycnprk642ndgggz3lxm36n";
  buildDepends = [
    dataDefault liftedBase monadControl transformers
  ];
  meta = {
    description = "Retry combinators for monadic actions that may fail";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
