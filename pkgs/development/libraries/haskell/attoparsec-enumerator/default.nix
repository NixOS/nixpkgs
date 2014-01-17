{ cabal, attoparsec, enumerator, text }:

cabal.mkDerivation (self: {
  pname = "attoparsec-enumerator";
  version = "0.3.2";
  sha256 = "1jrrdhzqjfb78bhnjpy0j0qywqd2j67an41pcn8y6331nzmzsrl8";
  buildDepends = [ attoparsec enumerator text ];
  meta = {
    homepage = "https://john-millikin.com/software/attoparsec-enumerator/";
    description = "Pass input from an enumerator to an Attoparsec parser";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
