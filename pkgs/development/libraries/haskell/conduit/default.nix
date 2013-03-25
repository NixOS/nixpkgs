{ cabal, doctest, hspec, liftedBase, mmorph, monadControl
, QuickCheck, resourcet, text, transformers, transformersBase, void
}:

cabal.mkDerivation (self: {
  pname = "conduit";
  version = "1.0.4.1";
  sha256 = "1fihn6ixs6cmim5y605w2mzjrcwplr58r835wq9k3arb25d5wnys";
  buildDepends = [
    liftedBase mmorph monadControl resourcet text transformers
    transformersBase void
  ];
  testDepends = [
    doctest hspec QuickCheck resourcet text transformers void
  ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Streaming data processing library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
