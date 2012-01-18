{ cabal, liftedBase, monadControl, text, transformers
, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "conduit";
  version = "0.0.4";
  sha256 = "1sc14nh21ba85azm4my5qnllnlbmsq5j6h1yd1mdsk2z3fb0x5zz";
  buildDepends = [
    liftedBase monadControl text transformers transformersBase
  ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Streaming data processing library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
