{ cabal, filepath, happy, haskellLexer }:

cabal.mkDerivation (self: {
  pname = "pretty-show";
  version = "1.6.5";
  sha256 = "0yn20gh2xwzvfwb9fdzxqqbbb6vvd4rlv5ancw4vc8p2kgfhwxf3";
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
