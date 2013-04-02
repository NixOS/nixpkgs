{ cabal, libedit }:

cabal.mkDerivation (self: {
  pname = "editline";
  version = "0.2.1.1";
  sha256 = "101zhzja14n8bhbrly7w2aywx3sxyzgyjdrmgpg4gn4alf4lzdlz";
  extraLibraries = [ libedit ];
  meta = {
    homepage = "http://code.haskell.org/editline";
    description = "Bindings to the editline library (libedit)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
