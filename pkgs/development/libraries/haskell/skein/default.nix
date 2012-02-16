{ cabal, Cabal, cereal, cryptoApi, tagged }:

cabal.mkDerivation (self: {
  pname = "skein";
  version = "0.1.0.5";
  sha256 = "12hyyydznss802v4pwfcpjr0y7241114a9z82xxq60q8dval8fyb";
  buildDepends = [ Cabal cereal cryptoApi tagged ];
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
