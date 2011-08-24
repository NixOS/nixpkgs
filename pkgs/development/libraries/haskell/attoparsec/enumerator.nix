{ cabal, attoparsec, enumerator }:

cabal.mkDerivation (self: {
  pname = "attoparsec-enumerator";
  version = "0.2.0.4";
  sha256 = "14v53vppcf4k3m4kid10pg5r3zsn894f36w1y2pzlc72w81fv3gd";
  buildDepends = [ attoparsec enumerator ];
  meta = {
    homepage = "http://john-millikin.com/software/attoparsec-enumerator/";
    description = "Convert an Attoparsec parser into an iteratee";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
