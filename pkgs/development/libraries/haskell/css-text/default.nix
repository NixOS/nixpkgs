{ cabal, attoparsec, Cabal, text }:

cabal.mkDerivation (self: {
  pname = "css-text";
  version = "0.1.1";
  sha256 = "10vb08rnfq987w7wrirw8ib1kzafxaaancswm4xpw46ha3rq1m0y";
  buildDepends = [ attoparsec Cabal text ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "CSS parser and renderer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
