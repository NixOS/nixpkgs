{ cabal, bindingsDSL }:

cabal.mkDerivation (self: {
  pname = "bindings-sophia";
  version = "0.2.0.2";
  sha256 = "0fiibm7nrsx9pzi2lvhhbw71bah6s22h3jvn417ng3lj6ghhzii6";
  buildDepends = [ bindingsDSL ];
  meta = {
    description = "Low-level bindings to sophia library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
