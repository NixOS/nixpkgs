{ cabal, blazeBuilder }:

cabal.mkDerivation (self: {
  pname = "fast-logger";
  version = "0.0.1";
  sha256 = "19ff2dhkh62i1ljsl90wnsblzk30dz0yx4kw5gk1hb22md7hakim";
  buildDepends = [ blazeBuilder ];
  meta = {
    description = "A fast logging system";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
