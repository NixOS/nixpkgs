{ cabal, cereal, cryptoApi, filepath, hspec, tagged }:

cabal.mkDerivation (self: {
  pname = "skein";
  version = "1.0.2";
  sha256 = "1wzy586lcr0pxsdf4lvqhbzq8bsm26gm71jlmv64i22f99n5s9h2";
  buildDepends = [ cereal cryptoApi tagged ];
  testDepends = [ cereal cryptoApi filepath hspec tagged ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/meteficha/skein";
    description = "Skein, a family of cryptographic hash functions. Includes Skein-MAC as well.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
