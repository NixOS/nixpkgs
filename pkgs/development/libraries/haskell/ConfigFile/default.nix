{ cabal, Cabal, MissingH, mtl, parsec }:

cabal.mkDerivation (self: {
  pname = "ConfigFile";
  version = "1.1.1";
  sha256 = "0w2yhbnqldhmj3d98j720l4lj4d08abqcff751p2slszdm5pw1jm";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ Cabal MissingH mtl parsec ];
  noHaddock = true;
  meta = {
    homepage = "http://software.complete.org/configfile";
    description = "Configuration file reading & writing";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
