{ cabal, binary, mtl, RepLib, transformers }:

cabal.mkDerivation (self: {
  pname = "unbound";
  version = "0.4.3";
  sha256 = "1lv60zpsvjfp9qnckwbphkfv0x9pz2qvaab3p4kj38fnlq2y20i4";
  buildDepends = [ binary mtl RepLib transformers ];
  meta = {
    homepage = "http://code.google.com/p/replib/";
    description = "Generic support for programming with names and binders";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
