{ cabal, deepseq, filepath, mtl, optparseApplicative, tagged, tasty
, temporary
}:

cabal.mkDerivation (self: {
  pname = "tasty-golden";
  version = "2.2.1";
  sha256 = "1q3x3vmck1yq7bf96f3ah5nadahfxjd4wr3dfh3ls549yz40x668";
  buildDepends = [
    deepseq filepath mtl optparseApplicative tagged tasty temporary
  ];
  meta = {
    homepage = "https://github.com/feuerbach/tasty-golden";
    description = "Golden tests support for tasty";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
