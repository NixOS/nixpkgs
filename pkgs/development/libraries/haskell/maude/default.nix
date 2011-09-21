{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "maude";
  version = "0.2.1";
  sha256 = "10igixljxfrpns2ffvk4g5dsv2pr8p1f7hc65z5x91n6x8zd01vi";
  buildDepends = [ text ];
  meta = {
    homepage = "https://code.google.com/p/maude-hs/";
    description = "An interface to the Maude rewriting system";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
