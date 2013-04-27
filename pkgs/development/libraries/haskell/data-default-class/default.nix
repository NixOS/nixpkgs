{ cabal }:

cabal.mkDerivation (self: {
  pname = "data-default-class";
  version = "0.0.1";
  sha256 = "0ccgr3jllinchqhw3lsn73ic6axk4196if5274rr1rghls0fxj5d";
  meta = {
    description = "A class for types with a default value";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
