{ cabal, dataDefault, semigroups }:

cabal.mkDerivation (self: {
  pname = "tagged";
  version = "0.2.3";
  sha256 = "0d4nn0lrgj9v5hy7wgm56dgfvb5021z24sz0xmqxjy2pzq7fxwhc";
  buildDepends = [ dataDefault semigroups ];
  meta = {
    homepage = "http://github.com/ekmett/tagged";
    description = "Provides newtype wrappers for phantom types to avoid unsafely passing dummy arguments";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
