{ cabal, Cabal, curl, feed, tagsoup, xml }:

cabal.mkDerivation (self: {
  pname = "download-curl";
  version = "0.1.3";
  sha256 = "17g5dnw4yxi4kf5x71bkk4wx1zl8yjs5dd34k6dgnw9wgkz97qw1";
  buildDepends = [ Cabal curl feed tagsoup xml ];
  meta = {
    homepage = "http://code.haskell.org/~dons/code/download-curl";
    description = "High-level file download based on URLs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
