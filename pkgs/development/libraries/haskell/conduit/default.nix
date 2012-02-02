{ cabal, liftedBase, monadControl, text, transformers
, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "conduit";
  version = "0.1.1.1";
  sha256 = "0gqkk5q329xbw565xd9xc0pz2ha66jkdbbjgwadvrjw1n52vaqg5";
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
