{ cabal, syb }:

cabal.mkDerivation (self: {
  pname = "srcloc";
  version = "0.3.0";
  sha256 = "1ymk8k0r9ckk7dalz3virvvpyrf4nw8xvb23cs6ibdjjbzsphpiz";
  buildDepends = [ syb ];
  meta = {
    homepage = "http://www.eecs.harvard.edu/~mainland/";
    description = "Data types for managing source code locations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
