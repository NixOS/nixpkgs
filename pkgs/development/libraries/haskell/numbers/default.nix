{ cabal, QuickCheck, testFramework, testFrameworkQuickcheck2 }:

cabal.mkDerivation (self: {
  pname = "numbers";
  version = "3000.2.0.0";
  sha256 = "035qc7dgh4nd661z4mm742v8y7xqdyyp0r0vkinxiifciqb1fkbm";
  testDepends = [
    QuickCheck testFramework testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "https://github.com/DanBurton/numbers#readme";
    description = "Various number types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
