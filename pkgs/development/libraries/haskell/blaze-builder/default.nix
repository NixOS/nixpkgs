{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "blaze-builder";
  version = "0.3.0.2";
  sha256 = "009njfm9g0fs7kg6q9c7qqfl69msw9q3d07xh3xg7layh09khsdb";
  buildDepends = [ text ];
  meta = {
    homepage = "http://github.com/meiersi/blaze-builder";
    description = "Efficient buffered output";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
