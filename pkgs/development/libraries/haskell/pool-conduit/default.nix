{ cabal, monadControl, resourcePool, resourcet, transformers }:

cabal.mkDerivation (self: {
  pname = "pool-conduit";
  version = "0.1.2";
  sha256 = "10lvq18pk9d4la5irr1qv1c9y4qbwlglmzgs7bz1d0g5232w3rv8";
  buildDepends = [
    monadControl resourcePool resourcet transformers
  ];
  meta = {
    homepage = "http://www.yesodweb.com/book/persistent";
    description = "Resource pool allocations via ResourceT";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
