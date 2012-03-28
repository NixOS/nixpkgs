{ cabal, Agda }:

cabal.mkDerivation (self: {
  pname = "Agda-executable";
  version = "2.3.0.1";
  sha256 = "156nzvpmqi7yizjr4yym2ybc0iv4nqfp84qrpdxcha682k298ib1";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ Agda ];
  meta = {
    homepage = "http://wiki.portal.chalmers.se/agda/";
    description = "Command-line program for type-checking and compiling Agda programs";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
