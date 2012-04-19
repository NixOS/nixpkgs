{ cabal }:

cabal.mkDerivation (self: {
  pname = "tagged";
  version = "0.4.2";
  sha256 = "16c2006b7f87003z6vz13fisw18iiqncjqk9x0f4wwzj6i70wgbw";
  meta = {
    homepage = "http://github.com/ekmett/tagged";
    description = "Haskell 98 phantom types to avoid unsafely passing dummy arguments";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
