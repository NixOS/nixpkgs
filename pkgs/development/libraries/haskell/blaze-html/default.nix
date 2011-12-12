{ cabal, blazeBuilder, text }:

cabal.mkDerivation (self: {
  pname = "blaze-html";
  version = "0.4.2.2";
  sha256 = "1fg0qgqml7ar3m0as9sk9zc260j2jvdsf5cdfrsify5l62ip060f";
  buildDepends = [ blazeBuilder text ];
  meta = {
    homepage = "http://jaspervdj.be/blaze";
    description = "A blazingly fast HTML combinator library for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
