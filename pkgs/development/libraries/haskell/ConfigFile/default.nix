{ cabal, MissingH, mtl, parsec }:

cabal.mkDerivation (self: {
  pname = "ConfigFile";
  version = "1.0.6";
  sha256 = "339722184b86d53d8b361933e572b6e1478824c7eba3fb66b67d0eb5245cd038";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ MissingH mtl parsec ];
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
