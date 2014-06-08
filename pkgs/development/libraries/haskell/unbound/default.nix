{ cabal, binary, mtl, RepLib, transformers }:

cabal.mkDerivation (self: {
  pname = "unbound";
  version = "0.4.3.1";
  sha256 = "1xkp47y7yg8dl95gf4w3iwddc3yivrhcxj184cfhrx6a9rbsflpz";
  buildDepends = [ binary mtl RepLib transformers ];
  meta = {
    homepage = "http://code.google.com/p/replib/";
    description = "Generic support for programming with names and binders";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
