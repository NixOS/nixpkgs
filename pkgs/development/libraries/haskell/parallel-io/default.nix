{ cabal, extensibleExceptions, random }:

cabal.mkDerivation (self: {
  pname = "parallel-io";
  version = "0.3.2.2";
  sha256 = "04swl1mp704ijrpmvw800x0fpzmrbd382p45kvqzynmkgqzx33a3";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ extensibleExceptions random ];
  meta = {
    homepage = "http://batterseapower.github.com/parallel-io";
    description = "Combinators for executing IO actions in parallel on a thread pool";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
