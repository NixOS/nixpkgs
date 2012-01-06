{ cabal, deepseq, nonNegative, parsec, QuickCheck, random
, storableRecord, utilityHt
}:

cabal.mkDerivation (self: {
  pname = "numeric-prelude";
  version = "0.3";
  sha256 = "0zxqfsgyg7gf051qjzv57bb1cvrbzlvvyyl2d3gmikyy6h3pis1f";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    deepseq nonNegative parsec QuickCheck random storableRecord
    utilityHt
  ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Numeric_Prelude";
    description = "An experimental alternative hierarchy of numeric type classes";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
