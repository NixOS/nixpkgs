{ cabal, liftedBase, monadControl, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "resourcet";
  version = "0.3.2.1";
  sha256 = "1gqcqbj9f13b9myrg7nhydrbbqnn80k69s65qsk3rc8wsqyk8i6g";
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
