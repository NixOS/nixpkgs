{ cabal, extensibleExceptions, mtl, random }:

cabal.mkDerivation (self: {
  pname = "QuickCheck";
  version = "2.1.1.1";
  sha256 = "626a6f7a69e2bea3b4fe7c573d0bc8da8c77f97035cb2d3a5e1c9fca382b59c9";
  buildDepends = [ extensibleExceptions mtl random ];
  meta = {
    homepage = "http://www.cse.chalmers.se/~koen";
    description = "Automatic testing of Haskell programs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
