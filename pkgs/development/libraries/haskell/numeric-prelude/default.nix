{ cabal, deepseq, nonNegative, parsec, QuickCheck, random
, storableRecord, utilityHt
}:

cabal.mkDerivation (self: {
  pname = "numeric-prelude";
  version = "0.4.0.3";
  sha256 = "0lgjnkvbz14cqsm5fjafl8g5mkclcdvpwa3kpz9radmg2x09rsnl";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    deepseq nonNegative parsec QuickCheck random storableRecord
    utilityHt
  ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Numeric_Prelude";
    description = "An experimental alternative hierarchy of numeric type classes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
