{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "polyparse";
  version = "1.8";
  sha256 = "08nr22r87q2yxxlcpvf35pkq56b4k3f1fzj3cvjnr7137k7c7ywn";
  buildDepends = [ text ];
  meta = {
    homepage = "http://code.haskell.org/~malcolm/polyparse/";
    description = "A variety of alternative parser combinator libraries";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
