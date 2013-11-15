{ cabal, filepath, mtl, optparseApplicative, tagged, tasty
, temporary
}:

cabal.mkDerivation (self: {
  pname = "tasty-golden";
  version = "2.2";
  sha256 = "0z49w4ksbbih3x0j170pfy93r2d68jw34hdni4s2p43kds52cakb";
  buildDepends = [
    filepath mtl optparseApplicative tagged tasty temporary
  ];
  meta = {
    homepage = "https://github.com/feuerbach/tasty-golden";
    description = "Golden tests support for tasty";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
