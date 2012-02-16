{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "failure";
  version = "0.2.0";
  sha256 = "1z7q2ldgfm0khar3vx7paz0jigzd720xjq2s0x02qf2m3iv0ilcv";
  buildDepends = [ transformers ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Failure";
    description = "A simple type class for success/failure computations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
