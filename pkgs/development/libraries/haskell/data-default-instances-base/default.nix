{ cabal, dataDefaultClass }:

cabal.mkDerivation (self: {
  pname = "data-default-instances-base";
  version = "0.0.1";
  sha256 = "1832nq6by91f1iw73ycvkbgn8kpra83pvf2q61hy47xffh0zy4pb";
  buildDepends = [ dataDefaultClass ];
  meta = {
    description = "Default instances for types in base";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
