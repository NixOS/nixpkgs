{ cabal, MissingH, mtl, parsec }:

cabal.mkDerivation (self: {
  pname = "ConfigFile";
  version = "1.1.0";
  sha256 = "0m5p56if711qi69lxw78746sb0jr5gqbmip5hdbb7lk4z5drgvhc";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ MissingH mtl parsec ];
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
