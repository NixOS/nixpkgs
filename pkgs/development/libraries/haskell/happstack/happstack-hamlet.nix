{ cabal, hamlet, happstackServer, text }:

cabal.mkDerivation (self: {
  pname = "happstack-hamlet";
  version = "7.0.3";
  sha256 = "0z4phykm2wxpdga47sdg76v7vmy32kav4nscizlkl648qjrx9k3r";
  buildDepends = [ hamlet happstackServer text ];
  meta = {
    homepage = "http://www.happstack.com/";
    description = "Support for Hamlet HTML templates in Happstack";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
