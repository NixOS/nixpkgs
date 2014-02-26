{ cabal, mtl, syb }:

cabal.mkDerivation (self: {
  pname = "th-desugar";
  version = "1.2.1";
  sha256 = "12a8m1vzfbn728psaiqxwngmksrbybci3g7a47z04rjbsjf3cy4v";
  buildDepends = [ mtl syb ];
  meta = {
    homepage = "http://www.cis.upenn.edu/~eir/packages/th-desugar";
    description = "Functions to desugar Template Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
