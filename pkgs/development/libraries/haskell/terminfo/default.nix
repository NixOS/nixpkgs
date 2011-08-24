{ cabal, extensibleExceptions, ncurses }:

cabal.mkDerivation (self: {
  pname = "terminfo";
  version = "0.3.2.2";
  sha256 = "1370vxvv32aarmk64yvwb8rav523xk7fg5h65cgxvn4ppjqv0f51";
  buildDepends = [ extensibleExceptions ];
  extraLibraries = [ ncurses ];
  meta = {
    homepage = "http://code.haskell.org/terminfo";
    description = "Haskell bindings to the terminfo library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
