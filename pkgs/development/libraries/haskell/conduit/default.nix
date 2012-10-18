{ cabal, liftedBase, monadControl, resourcet, text, transformers
, transformersBase, void
}:

cabal.mkDerivation (self: {
  pname = "conduit";
  version = "0.5.2.7";
  sha256 = "14bn755f25cin0wv775na85ngfx8ack31s15982zkqfva88xg48i";
  buildDepends = [
    liftedBase monadControl resourcet text transformers
    transformersBase void
  ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Streaming data processing library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
