{ cabal, QuickCheck }:

cabal.mkDerivation (self: {
  pname = "utility-ht";
  version = "0.0.8";
  sha256 = "02sm1xj5xa65hpkvl2yk89d9dlg3c2ap8qcviq9zj10asmsbzyd8";
  testDepends = [ QuickCheck ];
  meta = {
    description = "Various small helper functions for Lists, Maybes, Tuples, Functions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
