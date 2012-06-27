{ cabal, liftedBase, monadControl, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "resourcet";
  version = "0.3.2.2";
  sha256 = "0smff49b8sbxkvzlw59qgk5mdd4lp3605mcy4amjyz9fhcn3cky2";
  buildDepends = [
    liftedBase monadControl transformers transformersBase
  ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Deterministic allocation and freeing of scarce resources";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
