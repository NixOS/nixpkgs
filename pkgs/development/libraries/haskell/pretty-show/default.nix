{ cabal, filepath, happy, haskellLexer }:

cabal.mkDerivation (self: {
  pname = "pretty-show";
  version = "1.6.8";
  sha256 = "0vfb712dvbb91659sch62d06vm0451b9l4l0hdwnlbhzjymmh2rs";
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
