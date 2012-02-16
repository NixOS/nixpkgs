{ cabal }:

cabal.mkDerivation (self: {
  pname = "extensible-exceptions";
  version = "0.1.1.0";
  sha256 = "c252dc5a505332700f041d4e1fd3d309cde6158892f9c35339bf5e67bad7f781";
  meta = {
    description = "Extensible exceptions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
