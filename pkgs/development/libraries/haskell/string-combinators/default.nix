{ cabal, baseUnicodeSymbols, Cabal }:

cabal.mkDerivation (self: {
  pname = "string-combinators";
  version = "0.6.0.3";
  sha256 = "18jawxqvcj7zpvb0wf1zln12s03mp6nglhv5ccywrkb5x0r0557j";
  buildDepends = [ baseUnicodeSymbols Cabal ];
  meta = {
    homepage = "https://github.com/basvandijk/string-combinators";
    description = "Polymorphic functions to build and combine stringlike values";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
