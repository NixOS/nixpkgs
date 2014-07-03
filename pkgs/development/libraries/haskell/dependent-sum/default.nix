{ cabal }:

cabal.mkDerivation (self: {
  pname = "dependent-sum";
  version = "0.2.1.0";
  sha256 = "1h6wsrh206k6q3jcfdxvlsswbm47x30psp6x30l2z0j9jyf7jpl3";
  meta = {
    homepage = "https://github.com/mokus0/dependent-sum";
    description = "Dependent sum type";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
  };
})
