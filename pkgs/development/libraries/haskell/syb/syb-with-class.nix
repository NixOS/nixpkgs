{ cabal }:

cabal.mkDerivation (self: {
  pname = "syb-with-class";
  version = "0.6.1.4";
  sha256 = "0fi6m1a4017422kdmj1vvvzbks79jkcldp20h2nb7jsf8zvimfkc";
  meta = {
    description = "Scrap Your Boilerplate With Class";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
