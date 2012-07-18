{ cabal, deepseq, glpk, mtl }:

cabal.mkDerivation (self: {
  pname = "glpk-hs";
  version = "0.3.2";
  sha256 = "0y7imgzcnh6x36m5f6mns5ay1xhxy5p6i5nh16p2ywzjj0padcg8";
  buildDepends = [ deepseq mtl ];
  extraLibraries = [ glpk ];
  meta = {
    description = "Comprehensive GLPK linear programming bindings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
