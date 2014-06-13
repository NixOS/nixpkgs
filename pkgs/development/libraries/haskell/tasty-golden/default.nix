{ cabal, deepseq, filepath, mtl, optparseApplicative, tagged, tasty
, temporaryRc
}:

cabal.mkDerivation (self: {
  pname = "tasty-golden";
  version = "2.2.1.2";
  sha256 = "107c6i1abw6dsd3cx1bgiyk8dnih7i9x4bl4kw6dfnva2kjkp4d1";
  buildDepends = [
    deepseq filepath mtl optparseApplicative tagged tasty temporaryRc
  ];
  meta = {
    homepage = "https://github.com/feuerbach/tasty-golden";
    description = "Golden tests support for tasty";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
