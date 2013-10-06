{ cabal, parsec, randomFu, transformers }:

cabal.mkDerivation (self: {
  pname = "dice";
  version = "0.1";
  sha256 = "1rfx3vh983f3gc6si661zimhjl47ip30l3pvf7dysjirr3gffgz1";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ parsec randomFu transformers ];
  meta = {
    description = "Simplistic D&D style dice-rolling system";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
  };
})
