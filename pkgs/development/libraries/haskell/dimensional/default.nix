{ cabal, Cabal, numtype, time }:

cabal.mkDerivation (self: {
  pname = "dimensional";
  version = "0.10.1.2";
  sha256 = "0hdiwyzr4zzwz5h8m7nrcdf85n00byjchr6ghbasnsg3vg9p17wn";
  buildDepends = [ Cabal numtype time ];
  meta = {
    homepage = "http://dimensional.googlecode.com/";
    description = "Statically checked physical dimensions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
