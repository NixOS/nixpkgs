{ cabal, hspec, HUnit, mtl, syb }:

cabal.mkDerivation (self: {
  pname = "th-desugar";
  version = "1.4.1";
  sha256 = "1pjv301bshdmn3s5nrmmcx5d1b80c410lml73sai68dhx7v64vw2";
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
