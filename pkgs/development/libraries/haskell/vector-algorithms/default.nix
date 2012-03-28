{ cabal, primitive, vector }:

cabal.mkDerivation (self: {
  pname = "vector-algorithms";
  version = "0.5.4";
  sha256 = "0j16jmnmgksbzsq2vvxjmciywi91clak77i6zjjghvn9dpmnsmv2";
  buildDepends = [ primitive vector ];
  meta = {
    homepage = "http://code.haskell.org/~dolio/";
    description = "Efficient algorithms for vector arrays";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
