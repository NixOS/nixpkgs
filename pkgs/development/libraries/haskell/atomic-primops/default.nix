{ cabal, Cabal, primitive }:

cabal.mkDerivation (self: {
  pname = "atomic-primops";
  version = "0.6";
  sha256 = "0jj4mv9vzk7s257gnjs00fza6shr7j9bv8p48gj61yncg0qdypiz";
  buildDepends = [ Cabal primitive ];
  meta = {
    homepage = "https://github.com/rrnewton/haskell-lockfree/wiki";
    description = "A safe approach to CAS and other atomic ops in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
