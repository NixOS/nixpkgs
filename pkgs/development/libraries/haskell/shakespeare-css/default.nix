{ cabal, Cabal, parsec, shakespeare, text }:

cabal.mkDerivation (self: {
  pname = "shakespeare-css";
  version = "0.10.7";
  sha256 = "0cla600s5715glimlf58gndpp7njhm26j78bfm16cxia5psp5zav";
  buildDepends = [ Cabal parsec shakespeare text ];
  meta = {
    homepage = "http://www.yesodweb.com/book/templates";
    description = "Stick your haskell variables into css at compile time";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
