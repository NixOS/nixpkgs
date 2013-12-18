{ cabal, filepath, happy, haskellLexer }:

cabal.mkDerivation (self: {
  pname = "pretty-show";
  version = "1.6.2";
  sha256 = "0xhxyxymdjag2xczjrda5dkjc51m5k1nanpg9dmw0gr6wjaijbnp";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ filepath haskellLexer ];
  buildTools = [ happy ];
  meta = {
    homepage = "http://wiki.github.com/yav/pretty-show";
    description = "Tools for working with derived `Show` instances and generic inspection of values";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
