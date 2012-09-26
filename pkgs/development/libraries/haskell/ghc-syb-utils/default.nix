{ cabal, syb }:

cabal.mkDerivation (self: {
  pname = "ghc-syb-utils";
  version = "0.2.1.1";
  sha256 = "1fwlzqbkjn592jh01nccn99iii6047fg9f3hh255586nzngihh1l";
  buildDepends = [ syb ];
  meta = {
    homepage = "http://github.com/nominolo/ghc-syb";
    description = "Scrap Your Boilerplate utilities for the GHC API";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
