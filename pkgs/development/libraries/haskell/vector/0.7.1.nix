{ cabal, primitive }:

cabal.mkDerivation (self: {
  pname = "vector";
  version = "0.7.1";
  sha256 = "1cdbkabw49pgc1j5h96inpmhn8ly230885d22smmynrq369pmg07";
  buildDepends = [ primitive ];
  meta = {
    homepage = "http://code.haskell.org/vector";
    description = "Efficient Arrays";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
