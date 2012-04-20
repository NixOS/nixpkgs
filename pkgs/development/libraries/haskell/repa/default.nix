{ cabal, QuickCheck, vector }:

cabal.mkDerivation (self: {
  pname = "repa";
  version = "3.1.2.1";
  sha256 = "15g2l8f5d02jy63ljyvjdd2ymdml072bjylsxvn4xmr0jzmi689x";
  buildDepends = [ QuickCheck vector ];
  meta = {
    homepage = "http://repa.ouroborus.net";
    description = "High performance, regular, shape polymorphic parallel arrays";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
