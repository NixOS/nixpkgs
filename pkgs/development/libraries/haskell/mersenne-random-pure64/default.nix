{ cabal, random }:

cabal.mkDerivation (self: {
  pname = "mersenne-random-pure64";
  version = "0.2.0.3";
  sha256 = "0cyjfdl17n5al04vliykx0m7zncqh3201vn9b9fqfqqpmm61grqz";
  buildDepends = [ random ];
  meta = {
    homepage = "http://code.haskell.org/~dons/code/mersenne-random-pure64/";
    description = "Generate high quality pseudorandom numbers purely using a Mersenne Twister";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
