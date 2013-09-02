{ cabal, deepseq, hashable, HUnit, testFramework
, testFrameworkHunit, text
}:

cabal.mkDerivation (self: {
  pname = "case-insensitive";
  version = "1.1";
  sha256 = "1likcqdlhbbk78s887n5g9a4jjxxyh46hj4wc7l7snf6f9ygd5lj";
  buildDepends = [ deepseq hashable text ];
  testDepends = [ HUnit testFramework testFrameworkHunit text ];
  meta = {
    homepage = "https://github.com/basvandijk/case-insensitive";
    description = "Case insensitive string comparison";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
