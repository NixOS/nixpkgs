{cabal}:

cabal.mkDerivation (self : {
  pname = "data-default";
  version = "0.2.0.1";
  sha256 = "0hhrzaykwybqpig0kss4iq1i93ygb80g8i1chpr84akmvdr07w0i";
  meta = {
    description = "A class for types with a default value";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

