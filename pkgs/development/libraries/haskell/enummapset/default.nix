{ cabal, deepseq }:

cabal.mkDerivation (self: {
  pname = "enummapset";
  version = "0.5.2.0";
  sha256 = "065gxljrjw59rdf7abq0v0c29wg1ymg984ckixnjrcs1yks0c2js";
  buildDepends = [ deepseq ];
  meta = {
    homepage = "https://github.com/michalt/enummapset";
    description = "IntMap and IntSet with Enum keys/elements";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
