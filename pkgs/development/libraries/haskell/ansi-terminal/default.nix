{ cabal }:

cabal.mkDerivation (self: {
  pname = "ansi-terminal";
  version = "0.5.5";
  sha256 = "09r4nlpmkis6cp30jkymfas13hz6ph4zqxhvigrxn6s76v7nb5a8";
  isLibrary = true;
  isExecutable = true;
  meta = {
    homepage = "http://batterseapower.github.com/ansi-terminal";
    description = "Simple ANSI terminal support, with Windows compatibility";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
