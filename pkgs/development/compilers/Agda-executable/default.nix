{ cabal, Agda }:

cabal.mkDerivation (self: {
  pname = "Agda-executable";
  version = "2.3.0";
  sha256 = "1n1ak6z2vh356k9mk0zkiv6dqp9dvx97a7r21b0xnhwkmh3f8p5p";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ Agda ];
  meta = {
    homepage = "http://wiki.portal.chalmers.se/agda/";
    description = "Command-line program for type-checking and compiling Agda programs";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
