{ cabal, Agda }:

cabal.mkDerivation (self: {
  pname = "Agda-executable";
  version = "2.2.10";
  sha256 = "0jjlbz5vaz1pasfws1cy8wvllzdzv3sxm2lfj6bckl93kdrxlpy6";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ Agda ];
  meta = {
    homepage = "http://wiki.portal.chalmers.se/agda/";
    description = "Command-line program for type-checking and compiling Agda programs";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
