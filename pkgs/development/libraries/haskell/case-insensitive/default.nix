{ cabal, deepseq, hashable, HUnit, testFramework
, testFrameworkHunit, text
}:

cabal.mkDerivation (self: {
  pname = "case-insensitive";
  version = "1.0.0.2";
  sha256 = "11cczwg11y6pfsidj1i052rhri98sgg2qzf0ixgjq1gywakjx5f2";
  buildDepends = [ deepseq hashable text ];
  testDepends = [ HUnit testFramework testFrameworkHunit text ];
  meta = {
    homepage = "https://github.com/basvandijk/case-insensitive";
    description = "Case insensitive string comparison";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
