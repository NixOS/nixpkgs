{cabal}:

cabal.mkDerivation (self : {
  pname = "mersenne-random-pure64";
  version = "0.2.0.3";
  sha256 = "0cyjfdl17n5al04vliykx0m7zncqh3201vn9b9fqfqqpmm61grqz";
  meta = {
    description = "Generate high quality pseudorandom numbers purely using a Mersenne Twister";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

