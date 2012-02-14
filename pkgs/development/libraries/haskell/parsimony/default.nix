{ cabal, Cabal, text }:

cabal.mkDerivation (self: {
  pname = "parsimony";
  version = "1.3";
  sha256 = "0vbayvk989m85qfxxls74rn0v8ylb5l7lywp30sw2wybvi4r08lg";
  buildDepends = [ Cabal text ];
  meta = {
    description = "Monadic parser combinators derived from Parsec";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
