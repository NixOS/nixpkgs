{ cabal, liftedBase, monadControl, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "alternative-io";
  version = "0.0.1";
  sha256 = "01hypbci3hw2czkmx78ls51ycx518ich4k753jgv0z8ilrq8isch";
  buildDepends = [
    liftedBase monadControl transformers transformersBase
  ];
  meta = {
    description = "IO as Alternative instance (deprecated)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
