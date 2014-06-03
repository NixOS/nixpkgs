{ cabal, attoparsec, enumerator, text }:

cabal.mkDerivation (self: {
  pname = "attoparsec-enumerator";
  version = "0.3.3";
  sha256 = "0z57bbw97v92dkjp57zj9nfzsdas2n1qfw472k1aa84iqb6hbw9w";
  buildDepends = [ attoparsec enumerator text ];
  meta = {
    homepage = "https://john-millikin.com/software/attoparsec-enumerator/";
    description = "Pass input from an enumerator to an Attoparsec parser";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
