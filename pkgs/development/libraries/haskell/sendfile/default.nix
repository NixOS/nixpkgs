{ cabal, Cabal, network }:

cabal.mkDerivation (self: {
  pname = "sendfile";
  version = "0.7.4";
  sha256 = "1h02fjdivsb3divdn3wg2skmw3jcd0n4axhlpgmrrbf92c3m35rq";
  buildDepends = [ Cabal network ];
  meta = {
    homepage = "http://patch-tag.com/r/mae/sendfile";
    description = "A portable sendfile library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
