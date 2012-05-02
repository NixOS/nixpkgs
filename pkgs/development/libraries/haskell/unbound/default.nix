{ cabal, mtl, RepLib, transformers }:

cabal.mkDerivation (self: {
  pname = "unbound";
  version = "0.4.0.2";
  sha256 = "0vwbqrjrahg7ifsqgmq18ddmmczjxnsdz5w3kfgb4jpv1glwlxrh";
  buildDepends = [ mtl RepLib transformers ];
  meta = {
    homepage = "http://code.google.com/p/replib/";
    description = "Generic support for programming with names and binders";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
