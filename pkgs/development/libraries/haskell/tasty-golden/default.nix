{ cabal, filepath, mtl, optparseApplicative, tagged, tasty
, temporary
}:

cabal.mkDerivation (self: {
  pname = "tasty-golden";
  version = "2.2.0.1";
  sha256 = "0zr8ikg1j1nc29b6i23wb7zwbq0kmvjry7a1a6ldnz4p13m05q6d";
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
