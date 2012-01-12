{ cabal, liftedBase, monadControl, text, transformers
, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "conduit";
  version = "0.0.3";
  sha256 = "149xj6i2whpjf6jqsgfgvpbwni5r0v3qrg7g42i78bd6n40xma72";
  buildDepends = [
    liftedBase monadControl text transformers transformersBase
  ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "A pull-based approach to streaming data";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
