{ cabal, hspec, QuickCheck, zlib }:

cabal.mkDerivation (self: {
  pname = "zlib-bindings";
  version = "0.1.1.4";
  sha256 = "02ln0gv9kkq68s3n195q2mpqimxb6k4wqs731b1gg8wrbbkaxb6w";
  buildDepends = [ zlib ];
  testDepends = [ hspec QuickCheck zlib ];
  meta = {
    homepage = "http://github.com/snoyberg/zlib-bindings";
    description = "Low-level bindings to the zlib package";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
