{ cabal, nonNegative, parsec, QuickCheck, random, storableRecord
, utilityHt
}:

cabal.mkDerivation (self: {
  pname = "numeric-prelude";
  version = "0.2.2.1";
  sha256 = "12b2h103f43rlrfk3zck6mzbvw6v4jf8g4kxz1k14v201lrvb2da";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    nonNegative parsec QuickCheck random storableRecord utilityHt
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
