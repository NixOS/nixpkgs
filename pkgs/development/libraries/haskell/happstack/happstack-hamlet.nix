{ cabal, hamlet, happstackServer, text }:

cabal.mkDerivation (self: {
  pname = "happstack-hamlet";
  version = "6.2.4";
  sha256 = "1m03r1wk34lx9b2bmcrakcaaq701vcdkw2shxmqwk6fsbgh7qjp0";
  buildDepends = [ hamlet happstackServer text ];
  meta = {
    homepage = "http://www.happstack.com/";
    description = "Support for Hamlet HTML templates in Happstack";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
