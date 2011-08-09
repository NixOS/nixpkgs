{ cabal, QuickCheck, nonNegative, parsec, storableRecord, utilityHt
}:

cabal.mkDerivation (self: {
  pname = "numeric-prelude";
  version = "0.2.2";
  sha256 = "bc6adb8c2f04e0e1f62e183e052974700143dc93b1a3cbafe3562aa1f7a649fd";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    QuickCheck nonNegative parsec storableRecord utilityHt
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
