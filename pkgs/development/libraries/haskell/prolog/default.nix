{ cabal, mtl, parsec, syb, thLift, transformers }:

cabal.mkDerivation (self: {
  pname = "prolog";
  version = "0.1";
  sha256 = "00791fb1f84wq42wvacnjl290fbn28x9hknxsic3ksi3f7psladm";
  buildDepends = [ mtl parsec syb thLift transformers ];
  meta = {
    homepage = "https://github.com/Erdwolf/prolog";
    description = "A Prolog interpreter written in Haskell";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
