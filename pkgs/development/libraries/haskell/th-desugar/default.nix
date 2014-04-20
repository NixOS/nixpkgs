{ cabal, hspec, HUnit, mtl, syb }:

cabal.mkDerivation (self: {
  pname = "th-desugar";
  version = "1.3.1";
  sha256 = "1wi0c5d1w6vjjk580zhypgqnnkndcsx4cmx5qy01w97h6kyj8913";
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
