{ cabal, attoparsec, Cabal, enumerator, text }:

cabal.mkDerivation (self: {
  pname = "attoparsec-enumerator";
  version = "0.3";
  sha256 = "1sfqcr1mvny9gf0zzggwvs2b20knxrbb208rzaa86ay0b5b5jw5v";
  buildDepends = [ attoparsec Cabal enumerator text ];
  meta = {
    homepage = "https://john-millikin.com/software/attoparsec-enumerator/";
    description = "Pass input from an enumerator to an Attoparsec parser";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
