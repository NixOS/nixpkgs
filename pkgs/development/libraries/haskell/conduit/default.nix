{ cabal, liftedBase, monadControl, resourcet, text, transformers
, transformersBase, void
}:

cabal.mkDerivation (self: {
  pname = "conduit";
  version = "0.5.2.6";
  sha256 = "0zmls6gl02mdwapdggw340s7pn5fjsvaky40m31ph3n28qr71kww";
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
