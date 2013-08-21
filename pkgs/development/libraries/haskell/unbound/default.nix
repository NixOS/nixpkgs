{ cabal, mtl, RepLib, transformers }:

cabal.mkDerivation (self: {
  pname = "unbound";
  version = "0.4.2";
  sha256 = "1bnnnv4rmzb0pw7i56nzr7k7pahr9rcmlfi4xkpsjhrxmizcfml9";
  buildDepends = [ mtl RepLib transformers ];
  meta = {
    homepage = "http://code.google.com/p/replib/";
    description = "Generic support for programming with names and binders";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
