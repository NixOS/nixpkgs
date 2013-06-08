{ cabal, attoparsec, enumerator, text }:

cabal.mkDerivation (self: {
  pname = "attoparsec-enumerator";
  version = "0.3.1";
  sha256 = "10h6i23vhcishp599s4lbp0c46wcba99w6iv4ickdr1avrm9z2m7";
  buildDepends = [ attoparsec enumerator text ];
  meta = {
    homepage = "https://john-millikin.com/software/attoparsec-enumerator/";
    description = "Pass input from an enumerator to an Attoparsec parser";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
