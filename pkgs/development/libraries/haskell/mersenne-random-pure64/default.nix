{ cabal, random }:

cabal.mkDerivation (self: {
  pname = "mersenne-random-pure64";
  version = "0.2.0.4";
  sha256 = "0qh72ynfg1k4c70qxdzsa6f1x9wyxil2d9gi85c879wrc41k899h";
  buildDepends = [ random ];
  meta = {
    homepage = "http://code.haskell.org/~dons/code/mersenne-random-pure64/";
    description = "Generate high quality pseudorandom numbers purely using a Mersenne Twister";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
