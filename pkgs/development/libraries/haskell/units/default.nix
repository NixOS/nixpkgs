{ cabal, singletons }:

cabal.mkDerivation (self: {
  pname = "units";
  version = "2.0";
  sha256 = "1iv0pirhyp7crbkb008k14z57jl8c91r1sl8kqmb778xawb1hx52";
  buildDepends = [ singletons ];
  meta = {
    homepage = "http://www.cis.upenn.edu/~eir/packages/units";
    description = "A domain-specific type system for dimensional analysis";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
