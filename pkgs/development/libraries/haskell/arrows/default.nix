{ cabal, Stream }:

cabal.mkDerivation (self: {
  pname = "arrows";
  version = "0.4.4.0";
  sha256 = "1dcvv1vscyggwqmlm6j2sc29zy0wmhn6w4g617gbxxb1j28bm6a9";
  buildDepends = [ Stream ];
  meta = {
    homepage = "http://www.haskell.org/arrows/";
    description = "Arrow classes and transformers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
