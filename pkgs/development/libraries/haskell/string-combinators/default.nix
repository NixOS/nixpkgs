{ cabal, baseUnicodeSymbols }:

cabal.mkDerivation (self: {
  pname = "string-combinators";
  version = "0.6.0.2";
  sha256 = "1bsnli6376nq5dmcx8da2fakj7h73plqz6v1myzhkz1f6r3qcjfi";
  buildDepends = [ baseUnicodeSymbols ];
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
