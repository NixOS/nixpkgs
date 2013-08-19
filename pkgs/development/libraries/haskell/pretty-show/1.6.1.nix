{ cabal, filepath, haskellLexer }:

cabal.mkDerivation (self: {
  pname = "pretty-show";
  version = "1.6.1";
  sha256 = "17zdljvpf7ra9x3lny5kbjvmz3psn8y1k9cwbg97m017gh87gsh0";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ filepath haskellLexer ];
  meta = {
    homepage = "http://wiki.github.com/yav/pretty-show";
    description = "Tools for working with derived `Show` instances and generic inspection of values";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
