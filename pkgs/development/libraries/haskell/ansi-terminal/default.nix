{ cabal }:

cabal.mkDerivation (self: {
  pname = "ansi-terminal";
  version = "0.5.5.1";
  sha256 = "146kqp49dvsskws7pn54yynpac1sb1s51pbm4nkqj86wwp04f0lc";
  isLibrary = true;
  isExecutable = true;
  meta = {
    homepage = "http://batterseapower.github.com/ansi-terminal";
    description = "Simple ANSI terminal support, with Windows compatibility";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
