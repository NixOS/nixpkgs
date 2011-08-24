{ cabal }:

cabal.mkDerivation (self: {
  pname = "th-lift";
  version = "0.5.4";
  sha256 = "1ax5rniainbw4lynfng0wv8a6x2cfv7k69n5nv1pwpb4s76am1hi";
  meta = {
    description = "Derive Template Haskell's Lift class for datatypes";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
