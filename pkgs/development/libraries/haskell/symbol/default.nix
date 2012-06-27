{ cabal, syb }:

cabal.mkDerivation (self: {
  pname = "symbol";
  version = "0.1.1.1";
  sha256 = "1vda97jh9jrvb4l9v9m3xzv8z96jdwf5fji643i6ff3n3h9ysn77";
  buildDepends = [ syb ];
  meta = {
    homepage = "http://www.eecs.harvard.edu/~mainland/";
    description = "A 'Symbol' type for fast symbol comparison";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
