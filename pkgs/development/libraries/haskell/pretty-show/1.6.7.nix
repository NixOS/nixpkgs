{ cabal, filepath, happy, haskellLexer }:

cabal.mkDerivation (self: {
  pname = "pretty-show";
  version = "1.6.7";
  sha256 = "16qjp6cl3hyir5bchnncq95bp7nw5cpp5kd5mszkjjhzw1jj9srz";
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
