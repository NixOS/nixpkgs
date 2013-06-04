{ cabal, pipes, transformers }:

cabal.mkDerivation (self: {
  pname = "pipes-safe";
  version = "1.2.0";
  sha256 = "0ki9i9378j8kgw5dd91b38r686pcr9fl2vf9dfgfshia072ppggj";
  buildDepends = [ pipes transformers ];
  meta = {
    description = "Safety for the pipes ecosystem";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
