{ cabal, deepseq, nonNegative, parsec, QuickCheck, random
, storableRecord, utilityHt
}:

cabal.mkDerivation (self: {
  pname = "numeric-prelude";
  version = "0.3.0.1";
  sha256 = "14hi0l4pga4srrfypx4alsyq34y5wsanis6216cds3zjw6db3frg";
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
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
