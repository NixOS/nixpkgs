{ cabal, attoparsec, Cabal, filepath, network, time }:

cabal.mkDerivation (self: {
  pname = "hp2any-core";
  version = "0.11.1";
  sha256 = "146bigmch7dawyyakj0w55p0jdpnxkj8q5izjsswqqk0pdxia546";
  buildDepends = [ attoparsec Cabal filepath network time ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Hp2any";
    description = "Heap profiling helper library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
