{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "mtl";
  version = "2.2.0.1";
  sha256 = "0486cg4dp0p942zsg7yxpwn1jykx8p3gb794jaq0v3j44a7x00rb";
  buildDepends = [ transformers ];
  meta = {
    homepage = "http://github.com/ekmett/mtl";
    description = "Monad classes, using functional dependencies";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
