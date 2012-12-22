{ cabal, deepseq, glpk, mtl }:

cabal.mkDerivation (self: {
  pname = "glpk-hs";
  version = "0.3.4";
  sha256 = "0wyasd0dqi5nnh52lx980vnyhm0rwib0sd7qnpj4s9hq8rn994cm";
  buildDepends = [ deepseq mtl ];
  extraLibraries = [ glpk ];
  meta = {
    description = "Comprehensive GLPK linear programming bindings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
