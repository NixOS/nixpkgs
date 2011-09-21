{ cabal, mtl, parsec, syb }:

cabal.mkDerivation (self: {
  pname = "json";
  version = "0.4.4";
  sha256 = "102qmz55b2mgcca3q1c2pkcr6hz7kmpldad3f6blhmp1cz15f081";
  buildDepends = [ mtl parsec syb ];
  meta = {
    description = "Support for serialising Haskell to and from JSON";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
