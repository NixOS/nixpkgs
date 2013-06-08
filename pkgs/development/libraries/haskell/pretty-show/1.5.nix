{ cabal, filepath, haskellLexer }:

cabal.mkDerivation (self: {
  pname = "pretty-show";
  version = "1.5";
  sha256 = "1n04f9aypgbhkq0lbji9czv1mjfwv4f80w1c6hqs55gmzwif63m4";
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
