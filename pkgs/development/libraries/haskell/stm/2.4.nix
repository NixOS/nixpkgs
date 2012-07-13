{ cabal }:

cabal.mkDerivation (self: {
  pname = "stm";
  version = "2.4";
  sha256 = "13flyzh2vnqnap78qjawdh3150rmp9bxnlgynsf793lm1b3z15fl";
  meta = {
    description = "Software Transactional Memory";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
