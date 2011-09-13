{ cabal, deepseq }:

cabal.mkDerivation (self: {
  pname = "time";
  version = "1.4";
  sha256 = "0y9g7kazch7747x2s4f6yp1b1ys4s0r1r1n7qsvb3dwfbfmv93pz";
  buildDepends = [ deepseq ];
  meta = {
    homepage = "http://semantic.org/TimeLib/";
    description = "A time library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
