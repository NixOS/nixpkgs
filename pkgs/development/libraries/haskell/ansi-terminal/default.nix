{ cabal }:

cabal.mkDerivation (self: {
  pname = "ansi-terminal";
  version = "0.6";
  sha256 = "0a5zrq80yrj48s2cm8lns06p6wwnz72vs2wy0ryp0gw6rrg50fkg";
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
