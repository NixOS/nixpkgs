{ cabal, filepath, mtl, optparseApplicative, tagged, tasty
, temporary
}:

cabal.mkDerivation (self: {
  pname = "tasty-golden";
  version = "2.2.0.2";
  sha256 = "0wy29ybb31g34gjyx95an3azh111crvrrdhbbihjj064xvf6ddmy";
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
