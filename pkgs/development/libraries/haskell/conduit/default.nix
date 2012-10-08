{ cabal, liftedBase, monadControl, resourcet, text, transformers
, transformersBase, void
}:

cabal.mkDerivation (self: {
  pname = "conduit";
  version = "0.5.2.5";
  sha256 = "1savaq8n29cry75jl8rfk35q24s5bvm57j1zhnp3dcvj2i6w9k3y";
  buildDepends = [
    liftedBase monadControl resourcet text transformers
    transformersBase void
  ];
  jailbreak = true;
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Streaming data processing library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
