{ cabal, ncurses }:

cabal.mkDerivation (self: {
  pname = "terminfo";
  version = "0.3.2.5";
  sha256 = "1hadb1gv28c43xq78scalb4zzvbs6im2s0hq7ycrbsdgm6iryhbg";
  extraLibraries = [ ncurses ];
  meta = {
    homepage = "http://code.haskell.org/terminfo";
    description = "Haskell bindings to the terminfo library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
