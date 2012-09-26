{ cabal, mtl, RepLib, transformers }:

cabal.mkDerivation (self: {
  pname = "unbound";
  version = "0.4.1.1";
  sha256 = "0niv8mm4zjkndj0g32dgr32177dfp647hi32hqzwiis77vcfvdzb";
  buildDepends = [ mtl RepLib transformers ];
  meta = {
    homepage = "http://code.google.com/p/replib/";
    description = "Generic support for programming with names and binders";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
