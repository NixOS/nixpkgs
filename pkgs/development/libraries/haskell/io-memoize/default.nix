{ cabal, async }:

cabal.mkDerivation (self: {
  pname = "io-memoize";
  version = "1.1.0.0";
  sha256 = "1xnrzrvs5c3lrzdxm4hrqbh8chl8sxv2j98b28na73w8b7yv2agm";
  buildDepends = [ async ];
  meta = {
    description = "Memoize IO actions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
