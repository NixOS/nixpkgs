{ cabal }:

cabal.mkDerivation (self: {
  pname = "nats";
  version = "0.1.3";
  sha256 = "1kh7wvgjqq39f0dp2pnbazvr1zp6anb1ksgx3q1m1x0qgxkj0xxz";
  meta = {
    homepage = "http://github.com/ekmett/nats/";
    description = "Natural numbers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
