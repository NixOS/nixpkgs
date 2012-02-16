{ cabal, Cabal, libxml2, text }:

cabal.mkDerivation (self: {
  pname = "Pathfinder";
  version = "0.5.10";
  sha256 = "1k38p73jnkfcmmz94iqpzg2g6apsxflidvy8p9lwqyzfmg70brqf";
  buildDepends = [ Cabal text ];
  extraLibraries = [ libxml2 ];
  meta = {
    description = "Relational optimiser and code generator";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
