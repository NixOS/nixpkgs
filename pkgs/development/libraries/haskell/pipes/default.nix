{ cabal, mmorph, mtl, transformers, void }:

cabal.mkDerivation (self: {
  pname = "pipes";
  version = "4.0.0";
  sha256 = "0zsz739hjmfirwv9sacibpikwz48l006g95m8da1rqk5p1yyr2lm";
  buildDepends = [ mmorph mtl transformers void ];
  meta = {
    description = "Compositional pipelines";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
