{ cabal, cereal, cryptoApi, tagged }:

cabal.mkDerivation (self: {
  pname = "skein";
  version = "0.1.0.11";
  sha256 = "16iy3frzxzkiybl5cglvnmvxzziwr8361s00m7130dh82r3vc21q";
  buildDepends = [ cereal cryptoApi tagged ];
  meta = {
    homepage = "https://github.com/meteficha/skein";
    description = "Skein, a family of cryptographic hash functions. Includes Skein-MAC as well.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
