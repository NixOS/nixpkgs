{ cabal, liftedBase, monadControl, text, transformers
, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "conduit";
  version = "0.0.0.1";
  sha256 = "0l3q9jj0dpbn2ixjx6d9m6ss92dmfgd5xc7wgfpb9d0kfk2li0sv";
  buildDepends = [
    liftedBase monadControl text transformers transformersBase
  ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "A pull-based approach to streaming data";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
