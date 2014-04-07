{ cabal, hspec, QuickCheck, zlib }:

cabal.mkDerivation (self: {
  pname = "zlib-bindings";
  version = "0.1.1.5";
  sha256 = "02ciywlz4wdlymgc3jsnicz9kzvymjw1www2163gxidnz4wb8fy8";
  buildDepends = [ zlib ];
  testDepends = [ hspec QuickCheck zlib ];
  meta = {
    homepage = "http://github.com/snoyberg/zlib-bindings";
    description = "Low-level bindings to the zlib package. (deprecated)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
