{ cabal, blazeBuilder, Cabal, filepath }:

cabal.mkDerivation (self: {
  pname = "fast-logger";
  version = "0.0.2";
  sha256 = "1pwxhgcy4lmc63dnr9fihkmiclf60hrnsv8wzbsdg0jcj4qi0zr7";
  buildDepends = [ blazeBuilder Cabal filepath ];
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
