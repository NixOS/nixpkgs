{ cabal, random, testFramework, tfRandom }:

cabal.mkDerivation (self: {
  pname = "QuickCheck";
  version = "2.7.1";
  sha256 = "1hk19q7lfvja7g626hbbq0xs30zsgjpqfalgmdr24fy8sgdchm21";
  buildDepends = [ random tfRandom ];
  testDepends = [ testFramework ];
  patchPhase = ''
    sed -i -e 's|QuickCheck == .*,|QuickCheck,|' QuickCheck.cabal
  '';
  meta = {
    homepage = "http://code.haskell.org/QuickCheck";
    description = "Automatic testing of Haskell programs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
