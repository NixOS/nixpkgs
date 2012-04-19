{ cabal, cereal, cryptoApi, tagged }:

cabal.mkDerivation (self: {
  pname = "skein";
  version = "0.1.0.5";
  sha256 = "12hyyydznss802v4pwfcpjr0y7241114a9z82xxq60q8dval8fyb";
  buildDepends = [ cereal cryptoApi tagged ];
  patchPhase = ''
    sed -i -e 's|tagged  *>= 0.2 && < 0.3|tagged|' -e 's|crypto-api  *>= 0.6 && < 0.10|crypto-api|' skein.cabal
  '';
  meta = {
    description = "Skein, a family of cryptographic hash functions. Includes Skein-MAC as well.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
