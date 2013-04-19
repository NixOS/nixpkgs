{ cabal, nats }:

cabal.mkDerivation (self: {
  pname = "semigroups";
  version = "0.9.1";
  sha256 = "1i49180fw9bxnszmqc5jl877kjhkaa22py1jwfh69slx4z3giyxq";
  buildDepends = [ nats ];
  meta = {
    homepage = "http://github.com/ekmett/semigroups/";
    description = "Haskell 98 semigroups";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
