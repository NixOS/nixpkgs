{ cabal, dlist }:

cabal.mkDerivation (self: {
  pname = "smallcheck";
  version = "0.6.1";
  sha256 = "1p2bsc08lcyzmqdjc5qsr60dr03kvc8xw7kk4lbi9cnn9s9w90vb";
  buildDepends = [ dlist ];
  meta = {
    homepage = "https://github.com/feuerbach/smallcheck";
    description = "A property-based testing library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
