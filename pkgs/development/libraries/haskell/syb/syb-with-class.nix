{ cabal }:

cabal.mkDerivation (self: {
  pname = "syb-with-class";
  version = "0.6.1.3";
  sha256 = "0dmj9ah7az5lckamvm46pff0595p6v4pvzdv0lqq97gjs5i59y9d";
  meta = {
    description = "Scrap Your Boilerplate With Class";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
