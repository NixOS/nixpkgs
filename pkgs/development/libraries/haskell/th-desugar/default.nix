{ cabal, hspec, HUnit, mtl, syb }:

cabal.mkDerivation (self: {
  pname = "th-desugar";
  version = "1.4.0";
  sha256 = "0jadwqhk9dqnicg3p958a6cyfvl70amjc1hl7bhlygpxpdfffwad";
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
