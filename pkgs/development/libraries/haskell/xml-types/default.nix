{ cabal, deepseq, text }:

cabal.mkDerivation (self: {
  pname = "xml-types";
  version = "0.3.4";
  sha256 = "1689ijr4xxh4shxxvd51wdkpc535kzv6liqg4m1prag96aq05r8y";
  buildDepends = [ deepseq text ];
  meta = {
    homepage = "https://john-millikin.com/software/haskell-xml/";
    description = "Basic types for representing XML";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
