{ cabal, ncurses }:

cabal.mkDerivation (self: {
  pname = "terminfo";
  version = "0.3.2.4";
  sha256 = "06kwyp8maf9ylhz8rypy086dfdfs1k1h1b8xyyfvz1bzxsw63k7y";
  extraLibraries = [ ncurses ];
  meta = {
    homepage = "http://code.haskell.org/terminfo";
    description = "Haskell bindings to the terminfo library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
