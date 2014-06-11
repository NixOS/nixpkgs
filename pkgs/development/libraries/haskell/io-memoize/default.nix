{ cabal, spawn }:

cabal.mkDerivation (self: {
  pname = "io-memoize";
  version = "1.0.0.0";
  sha256 = "1z6aimyg7wasaqmacpch7skfm9iyl7khd54lfmb8iwghyfvah5d0";
  buildDepends = [ spawn ];
  meta = {
    description = "Memoize IO actions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
