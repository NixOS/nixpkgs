{ cabal }:

cabal.mkDerivation (self: {
  pname = "html";
  version = "1.0.1.2";
  sha256 = "0c35495ea33d65e69c69bc7441ec8e1af69fbb43433c2aa3406c0a13a3ab3061";
  meta = {
    description = "HTML combinator library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
