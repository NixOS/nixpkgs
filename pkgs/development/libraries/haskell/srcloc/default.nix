{ cabal, syb, symbol }:

cabal.mkDerivation (self: {
  pname = "srcloc";
  version = "0.1.2";
  sha256 = "08awipz6al7jk7d974am5v9fkp87i5dy6d457mx1rv7lczlyhws9";
  buildDepends = [ syb symbol ];
  meta = {
    homepage = "http://www.eecs.harvard.edu/~mainland/";
    description = "Data types for managing source code locations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
