{ cabal, deepseq, filepath, mtl, optparseApplicative, tagged, tasty
, tastyHunit, temporaryRc
}:

cabal.mkDerivation (self: {
  pname = "tasty-golden";
  version = "2.2.2.3";
  sha256 = "0vphim4qbx0g53xvh8x90k0l5r6afivbb4y31nvbq2avmrm1i82w";
  buildDepends = [
    deepseq filepath mtl optparseApplicative tagged tasty temporaryRc
  ];
  testDepends = [ filepath tasty tastyHunit temporaryRc ];
  meta = {
    homepage = "https://github.com/feuerbach/tasty-golden";
    description = "Golden tests support for tasty";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
