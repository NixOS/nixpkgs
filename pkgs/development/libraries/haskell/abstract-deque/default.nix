{ cabal, HUnit }:

cabal.mkDerivation (self: {
  pname = "abstract-deque";
  version = "0.1.6";
  sha256 = "13s8xbr31sqj8n3bh4xp82fqw5d5g1a27fpfqw69jfmr5xc9s1za";
  buildDepends = [ HUnit ];
  meta = {
    homepage = "https://github.com/rrnewton/haskell-lockfree-queue/wiki";
    description = "Abstract, parameterized interface to mutable Deques";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
