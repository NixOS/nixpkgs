{ cabal, Cabal, liftedBase, monadControl, text, transformers
, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "conduit";
  version = "0.2.1";
  sha256 = "1350n6nylvn62pdnm1cpm75yli9x3adf9m9jjz04z0gmzd3mvhd9";
  buildDepends = [
    Cabal liftedBase monadControl text transformers transformersBase
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
