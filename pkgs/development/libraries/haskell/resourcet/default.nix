{ cabal, liftedBase, monadControl, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "resourcet";
  version = "0.3.1";
  sha256 = "0nz1rz0nrs693hfav687rci3rhrhsmnjb93949mxgyd0ka5pw90l";
  buildDepends = [
    liftedBase monadControl transformers transformersBase
  ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Deterministic allocation and freeing of scarce resources";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
