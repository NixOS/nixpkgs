{ cabal }:

cabal.mkDerivation (self: {
  pname = "syb-with-class";
  version = "0.6.1.2";
  sha256 = "1hzwhfpl4w5nblkr2l4l4i7xxkvv7n5adr3i9miqmw1krlxs852d";
  meta = {
    description = "Scrap Your Boilerplate With Class";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
