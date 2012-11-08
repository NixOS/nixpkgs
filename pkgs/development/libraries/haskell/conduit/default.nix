{ cabal, liftedBase, monadControl, resourcet, text, transformers
, transformersBase, void
}:

cabal.mkDerivation (self: {
  pname = "conduit";
  version = "0.5.4";
  sha256 = "1scfwaj1f2b2kmhbj9njkj23mvsgf07xq85s9kcniqk579iklrja";
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
