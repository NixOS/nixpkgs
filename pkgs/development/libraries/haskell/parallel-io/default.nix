{ cabal, extensibleExceptions, random }:

cabal.mkDerivation (self: {
  pname = "parallel-io";
  version = "0.3.3";
  sha256 = "0i86x3bf8pjlg6mdg1zg5lcrjpg75pbqs2mrgrbp4z4bkcmw051s";
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
