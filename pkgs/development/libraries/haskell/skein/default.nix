{ cabal, cereal, cryptoApi, filepath, hspec, tagged }:

cabal.mkDerivation (self: {
  pname = "skein";
  version = "1.0.8";
  sha256 = "0qga3r73zzbj4kkwl8c3p7d1myjyv6dv6g0dwc77fqnmikzcnils";
  buildDepends = [ cereal cryptoApi tagged ];
  testDepends = [ cereal cryptoApi filepath hspec tagged ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/meteficha/skein";
    description = "Family of cryptographic hash functions (includes Skein-MAC)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
