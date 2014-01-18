{ cabal, cereal, cryptoApi, filepath, hspec, tagged }:

cabal.mkDerivation (self: {
  pname = "skein";
  version = "1.0.8.1";
  sha256 = "1xh8hx1d8hk3kqg07pb2ikc814037bw1xhawskrpxq3x37xff4q4";
  buildDepends = [ cereal cryptoApi tagged ];
  testDepends = [ cereal cryptoApi filepath hspec tagged ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/meteficha/skein";
    description = "Skein, a family of cryptographic hash functions. Includes Skein-MAC as well.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
