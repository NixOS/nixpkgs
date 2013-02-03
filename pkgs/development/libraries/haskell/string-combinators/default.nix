{ cabal, baseUnicodeSymbols }:

cabal.mkDerivation (self: {
  pname = "string-combinators";
  version = "0.6.0.4";
  sha256 = "0r1za5ypx9fz073h1yljjdkxmz0h77vg94bk827ndwkfgzgpzvh7";
  buildDepends = [ baseUnicodeSymbols ];
  meta = {
    homepage = "https://github.com/basvandijk/string-combinators";
    description = "Polymorphic functions to build and combine stringlike values";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
