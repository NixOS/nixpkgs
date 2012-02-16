{ cabal, Cabal, extensibleExceptions, ncurses }:

cabal.mkDerivation (self: {
  pname = "terminfo";
  version = "0.3.2.3";
  sha256 = "06y2vx7d4hl55p3p1c7yj2lx8yaw14c5h2qclj8m5xg2wkifnf5f";
  buildDepends = [ Cabal extensibleExceptions ];
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
