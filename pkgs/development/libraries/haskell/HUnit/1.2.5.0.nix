{ cabal, deepseq }:

cabal.mkDerivation (self: {
  pname = "HUnit";
  version = "1.2.5.0";
  sha256 = "0yxa3clrrjwg9faa3vsqb44xdzhdgwji56lrh7sa7dgq8bv1h6nr";
  buildDepends = [ deepseq ];
  meta = {
    homepage = "http://hunit.sourceforge.net/";
    description = "A unit testing framework for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
