{ cabal, primitive, vector }:

cabal.mkDerivation (self: {
  pname = "vector-algorithms";
  version = "0.5.2";
  sha256 = "0ijn4hfaxqjvm91d7mihv62bdd7ph15h880w9lmbr93czbsp8mw1";
  buildDepends = [ primitive vector ];
  meta = {
    homepage = "http://code.haskell.org/~dolio/";
    description = "Efficient algorithms for vector arrays";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
