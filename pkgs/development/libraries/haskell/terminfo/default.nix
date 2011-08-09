{cabal, extensibleExceptions, ncurses}:

cabal.mkDerivation (self : {
  pname = "terminfo";
  version = "0.3.2";
  sha256 = "0sfb6p6gj29wahp45plai7bygyyhhcaw6ld5xf90clkxy5pcsw1a";
  propagatedBuildInputs = [extensibleExceptions ncurses];
  meta = {
    homepage = "http://code.haskell.org/terminfo";
    description = "Haskell bindings to the terminfo library.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
