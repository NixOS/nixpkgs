{ cabal, ChasingBottoms, deepseq, hashable, HUnit, QuickCheck
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "unordered-containers";
  version = "0.2.3.2";
  sha256 = "0fgfb2zqa2zi2hb9nkj92nwnxr54wkqa6gmqbcn4h5zks5anfvn5";
  buildDepends = [ deepseq hashable ];
  testDepends = [
    ChasingBottoms hashable HUnit QuickCheck testFramework
    testFrameworkHunit testFrameworkQuickcheck2
  ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/tibbe/unordered-containers";
    description = "Efficient hashing-based container types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
