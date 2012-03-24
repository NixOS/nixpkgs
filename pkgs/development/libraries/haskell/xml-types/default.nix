{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "xml-types";
  version = "0.3.1";
  sha256 = "0ffmmidb9a1hqfbmvjxjvij2wfrqqlyjc7m7n81czrcrrsmyc1kc";
  buildDepends = [ text ];
  meta = {
    homepage = "https://john-millikin.com/software/haskell-xml/";
    description = "Basic types for representing XML";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
