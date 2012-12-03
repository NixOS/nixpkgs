{ cabal, liftedBase, monadControl, resourcet, text, transformers
, transformersBase, void
}:

cabal.mkDerivation (self: {
  pname = "conduit";
  version = "0.5.5";
  sha256 = "0av12gaxsrfmsbs70y532wfwnpz9v6ymn182dr8phpqn8d9lx2iq";
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
