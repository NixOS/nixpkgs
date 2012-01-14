{ cabal, cereal, cryptoApi, tagged }:

cabal.mkDerivation (self: {
  pname = "skein";
  version = "0.1.0.4";
  sha256 = "1m910kvm1ba9cl3ghr6j393xf1lvxb4ms55nipnzc5zg7r2xzh96";
  buildDepends = [ cereal cryptoApi tagged ];
  meta = {
    description = "Skein, a family of cryptographic hash functions. Includes Skein-MAC as well.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
