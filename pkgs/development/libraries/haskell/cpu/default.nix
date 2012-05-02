{ cabal }:

cabal.mkDerivation (self: {
  pname = "cpu";
  version = "0.1.0";
  sha256 = "020s1cv3qkhjq0gypxligg2x68izb3z82krv8y1m1k360554nqyg";
  isLibrary = true;
  isExecutable = true;
  meta = {
    homepage = "http://github.com/vincenthz/hs-cpu";
    description = "Cpu information and properties helpers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
