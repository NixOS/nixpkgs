{ cabal, extensibleExceptions, random }:

cabal.mkDerivation (self: {
  pname = "parallel-io";
  version = "0.3.2";
  sha256 = "1n9y1d1lcdwvhjsfqdlxknl89fxncq17kgin43wlki0c39cgirga";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ extensibleExceptions random ];
  jailbreak = true;
  meta = {
    homepage = "http://batterseapower.github.com/parallel-io";
    description = "Combinators for executing IO actions in parallel on a thread pool";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
