{ cabal, network, parsec }:

cabal.mkDerivation (self: {
  pname = "HTTP";
  version = "3001.1.5";
  sha256 = "e34d9f979bafbbf2e45bf90a9ee9bfd291f3c67c291a250cc0a6378431578aeb";
  buildDepends = [ network parsec ];
  meta = {
    homepage = "http://www.haskell.org/http/";
    description = "A library for client-side HTTP";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
