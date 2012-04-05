{ cabal, liftedBase, monadControl, resourcet, text, transformers
, transformersBase, void
}:

cabal.mkDerivation (self: {
  pname = "conduit";
  version = "0.4.0.1";
  sha256 = "1n4a42ayww55hvvsnis6gdfwfciwxpzz0wxa0b3ybvmyr0jsidiq";
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
