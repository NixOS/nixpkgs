{ cabal, cereal, network }:

cabal.mkDerivation (self: {
  pname = "socks";
  version = "0.4.0";
  sha256 = "0181qyxn7n47i7dqzw9yymbf73yr5v91iqjq01iyy43b4vab2ha8";
  buildDepends = [ cereal network ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-socks";
    description = "Socks proxy (version 5) implementation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
