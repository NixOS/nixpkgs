{ cabal, deepseq, glpk, mtl }:

cabal.mkDerivation (self: {
  pname = "glpk-hs";
  version = "0.3.3";
  sha256 = "1pnq0v5va7f40ky9xb8c4z9wcmmnny2vk4afasz5pwivbxh42mfl";
  buildDepends = [ deepseq mtl ];
  extraLibraries = [ glpk ];
  meta = {
    description = "Comprehensive GLPK linear programming bindings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
