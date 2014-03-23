{ cabal, hspec, HUnit, mtl, syb }:

cabal.mkDerivation (self: {
  pname = "th-desugar";
  version = "1.3.0";
  sha256 = "1wfypk1hcxr2918qp63df5xlx00rqwnaa59mivnlqs558g4kjx6j";
  buildDepends = [ mtl syb ];
  testDepends = [ hspec HUnit mtl syb ];
  meta = {
    homepage = "http://www.cis.upenn.edu/~eir/packages/th-desugar";
    description = "Functions to desugar Template Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
