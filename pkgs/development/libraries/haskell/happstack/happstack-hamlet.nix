{ cabal, hamlet, happstackServer, text }:

cabal.mkDerivation (self: {
  pname = "happstack-hamlet";
  version = "7.0.0";
  sha256 = "15r6xpyg193iwqin96mn7c9x5w7l8q9m3vbgiwv7bxvhdrl1dp7j";
  buildDepends = [ hamlet happstackServer text ];
  patchPhase = ''
    sed -i 's|hamlet >= 0.10 && <0.11|hamlet|' happstack-hamlet.cabal
  '';
  meta = {
    homepage = "http://www.happstack.com/";
    description = "Support for Hamlet HTML templates in Happstack";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
