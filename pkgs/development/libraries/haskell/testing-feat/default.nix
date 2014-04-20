{ cabal, mtl, QuickCheck, tagshare }:

cabal.mkDerivation (self: {
  pname = "testing-feat";
  version = "0.4.0.1";
  sha256 = "1fqp5k8kwnn7qqggyy5scsxmkvd1pibc5sfs7v1myrp0azkc25cp";
  buildDepends = [ mtl QuickCheck tagshare ];
  meta = {
    description = "Functional Enumeration of Algebraic Types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
