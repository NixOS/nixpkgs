{ cabal }:

cabal.mkDerivation (self: {
  pname = "syb-with-class";
  version = "0.6.1.1";
  sha256 = "15i6df470c2qcf9vc05yg809c5imrj00mf72p5njapx88qnk2p67";
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
